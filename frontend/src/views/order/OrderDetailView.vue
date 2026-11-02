<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { orderDetail, digitalContent, applyRefund as applyRefundApi, createPayment, mockPay, queryPayment, myRefunds } from '../../api/order'
import { startPayPolling } from '../../utils/payPolling'
import PageTitle from '../../components/PageTitle.vue'
const route=useRoute(),order=ref(null),loading=ref(false),paying=ref(false),content=ref(''),refundOpen=ref(false),refundBusy=ref(false),refundForm=reactive({reason:'',description:''}),latestRefund=ref(null)
let stopPayPolling=null
const REFUND_STATE={0:{text:'退款申请处理中，等待管理员审核',type:'warning'},1:{text:'退款已通过，正在执行退款',type:'warning'},2:{text:'',type:'info'},3:{text:'该订单已退款',type:'success'}}
const refundState=computed(()=>latestRefund.value?REFUND_STATE[Number(latestRefund.value.status)]:null)
const hasActiveRefund=computed(()=>latestRefund.value&&Number(latestRefund.value.status)!==2)
const canApplyRefund=computed(()=>order.value&&[1,2,4].includes(Number(order.value.status))&&!hasActiveRefund.value&&!(order.value.productType==='DIGITAL'&&Number(order.value.status)===1&&hasAccessedDigital()))
function hasAccessedDigital(){const items=order.value?.items||[];return items.length?items.some(i=>i.productType==='DIGITAL'&&i.digitalContentAccessedAt):false}
async function load(){loading.value=true;try{order.value=await orderDetail(route.params.id);try{const p=await myRefunds({current:1,size:50});const list=(p?.records||[]).filter(r=>r.orderId===order.value.id);latestRefund.value=list.length?list[0]:null}catch(e){latestRefund.value=null}}finally{loading.value=false}}
async function pay(){if(!order.value||Number(order.value.status)!==0||paying.value)return;paying.value=true;try{const result=await createPayment({orderId:order.value.id});if(result.payUrl){window.open(result.payUrl,'_blank','noopener');ElMessage.info('已打开支付宝收银台，支付完成后本页自动更新');if(stopPayPolling)stopPayPolling();stopPayPolling=startPayPolling(result.paymentNo,{expireTime:result.expireTime,onPaid:()=>{ElMessage.success('支付成功');load()},onClosed:()=>{ElMessage.warning('支付单已关闭，如已完成付款请稍后刷新查看');load()}})}else if(result.paymentNo){await mockPay(result.paymentNo);const status=await queryPayment(result.paymentNo);ElMessage.success(`模拟支付完成，支付状态：${status.status}`)}await load()}finally{paying.value=false}}
async function getContent(){content.value=await digitalContent(order.value.orderNo);ElMessage.success('已获取数字内容授权链接')}
async function submitRefund(){
  if(!refundForm.reason.trim())return ElMessage.warning('请填写退款原因');
  refundBusy.value=true;
  try{
    await applyRefundApi({orderId:order.value.id,reason:refundForm.reason.trim(),description:refundForm.description.trim()||null,images:[]});
    refundOpen.value=false;refundForm.reason='';refundForm.description='';
    ElMessage.success('退款申请已提交，等待管理员审核（本页已同步退款进度）');
    await load()
  }catch(e){/* 失败原因由全局拦截器 toast */}finally{refundBusy.value=false}
}
onMounted(load);watch(()=>route.params.id,load);onBeforeUnmount(()=>{if(stopPayPolling)stopPayPolling()})
</script>
<template><PageTitle eyebrow="ORDER DETAIL" title="订单详情"/><div v-loading="loading" class="content-card" v-if="order"><el-descriptions :column="2" border><el-descriptions-item label="订单编号">{{order.orderNo}}</el-descriptions-item><el-descriptions-item label="订单状态">{{order.statusText}}</el-descriptions-item><el-descriptions-item label="商品">{{order.albumTitle}}</el-descriptions-item><el-descriptions-item label="商品形态">{{order.productType}}</el-descriptions-item><el-descriptions-item label="数量">{{order.quantity}}</el-descriptions-item><el-descriptions-item label="金额">¥ {{order.totalAmount}}</el-descriptions-item><el-descriptions-item label="收货人">{{order.receiverName||'数字内容订单'}}</el-descriptions-item><el-descriptions-item label="联系电话">{{order.receiverPhone||'—'}}</el-descriptions-item><el-descriptions-item label="收货地址" :span="2">{{order.receiverAddress||'—'}}</el-descriptions-item><el-descriptions-item label="物流" :span="2">{{order.carrier||'—'}} {{order.trackingNo||''}}</el-descriptions-item></el-descriptions><div class="actions" style="margin-top:20px"><el-button v-if="Number(order.status)===0" type="primary" :loading="paying" @click="pay">立即支付</el-button><el-button v-if="order.productType==='DIGITAL'&&[1,2].includes(Number(order.status))" type="primary" @click="getContent">获取数字内容</el-button><el-button v-if="canApplyRefund" @click="refundOpen=true">申请退款</el-button></div><el-alert v-if="refundState&&refundState.text" :title="refundState.text" :description="Number(latestRefund.status)===2&&latestRefund.auditRemark?`拒绝原因：${latestRefund.auditRemark}，可重新申请`:null" :type="refundState.type==='info'?'warning':refundState.type" :closable="false" show-icon style="margin-top:16px"/><p v-if="content" class="content-card">{{content}}</p><el-dialog v-model="refundOpen" title="申请退款" width="min(560px,92vw)"><el-form label-position="top" @submit.prevent><el-form-item label="退款原因"><el-input v-model="refundForm.reason" maxlength="100" show-word-limit placeholder="简要说明退款原因"/></el-form-item><el-form-item label="详细说明"><el-input v-model="refundForm.description" type="textarea" maxlength="500" :rows="3" placeholder="补充说明（可选）"/></el-form-item></el-form><template #footer><el-button @click="refundOpen=false">取消</el-button><el-button type="primary" :loading="refundBusy" @click="submitRefund">{{refundBusy?'提交中…':'提交申请'}}</el-button></template></el-dialog></div></template>
