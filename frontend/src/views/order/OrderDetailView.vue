<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { orderDetail, digitalContent, applyRefund as applyRefundApi, createPayment, mockPay, queryPayment, myRefunds } from '../../api/order'
import { startPayPolling } from '../../utils/payPolling'
import PageTitle from '../../components/PageTitle.vue'
import OrderAddressDialog from '../../components/OrderAddressDialog.vue'
import LogisticsTrackDialog from '../../components/LogisticsTrackDialog.vue'
import BlindboxReveal from '../../components/BlindboxReveal.vue'
const route=useRoute(),order=ref(null),loading=ref(false),paying=ref(false),content=ref(''),refundOpen=ref(false),refundBusy=ref(false),refundForm=reactive({reason:'',description:'',returnCarrier:'',returnTrackingNo:''}),latestRefund=ref(null),addrOpen=ref(false),trackOpen=ref(false)
let stopPayPolling=null
const REFUND_STATE={0:{text:'退款申请处理中，等待管理员审核',type:'warning'},1:{text:'退款已通过，正在执行退款',type:'warning'},2:{text:'',type:'info'},3:{text:'该订单已退款',type:'success'}}
const refundState=computed(()=>latestRefund.value?REFUND_STATE[Number(latestRefund.value.status)]:null)
const hasActiveRefund=computed(()=>latestRefund.value&&Number(latestRefund.value.status)!==2)
const itemCount=computed(()=>order.value?.items?.length||0)
const totalQuantity=computed(()=>(order.value?.items||[]).reduce((sum,i)=>sum+Number(i.quantity||0),0))
// 盲盒开箱:已支付+已抽取 → 开箱动画;已支付+未抽取 → 轮询等抽取完成
const isBlindbox=computed(()=>Number(order.value?.orderType)===2)
const drawFailed=computed(()=>isBlindbox.value&&String(order.value?.drawSummary||'').startsWith('抽取失败'))
const showReveal=computed(()=>isBlindbox.value&&[1,2].includes(Number(order.value?.status))&&order.value?.drawSummary&&!drawFailed.value)
const drawPending=computed(()=>isBlindbox.value&&Number(order.value?.status)===1&&!order.value?.drawSummary)
let drawPollTimer=null,drawPollCount=0
function scheduleDrawPoll(){
  if(drawPollTimer)return
  drawPollCount=0
  drawPollTimer=setInterval(async()=>{
    drawPollCount++
    if(!order.value||!drawPending.value||drawPollCount>15){clearInterval(drawPollTimer);drawPollTimer=null;return}
    await load(true)
  },2000)
}
const canApplyRefund=computed(()=>order.value&&[1,2,4].includes(Number(order.value.status))&&!hasActiveRefund.value&&!(order.value.productType==='DIGITAL'&&Number(order.value.status)===1&&hasAccessedDigital()))
function hasAccessedDigital(){const items=order.value?.items||[];return items.length?items.some(i=>i.productType==='DIGITAL'&&i.digitalContentAccessedAt):false}
async function load(quiet){if(!quiet)loading.value=true;try{order.value=await orderDetail(route.params.id);try{const p=await myRefunds({current:1,size:50});const list=(p?.records||[]).filter(r=>r.orderId===order.value.id);latestRefund.value=list.length?list[0]:null}catch(e){latestRefund.value=null}}finally{if(!quiet)loading.value=false}if(drawPending.value)scheduleDrawPoll()}
async function pay(){if(!order.value||Number(order.value.status)!==0||paying.value)return;paying.value=true;try{const result=await createPayment({orderId:order.value.id});if(result.payUrl){window.open(result.payUrl,'_blank','noopener');ElMessage.info('已打开支付宝收银台，支付完成后本页自动更新');if(stopPayPolling)stopPayPolling();stopPayPolling=startPayPolling(result.paymentNo,{expireTime:result.expireTime,onPaid:()=>{ElMessage.success('支付成功');load()},onClosed:()=>{ElMessage.warning('支付单已关闭，如已完成付款请稍后刷新查看');load()}})}else if(result.paymentNo){await mockPay(result.paymentNo);const status=await queryPayment(result.paymentNo);ElMessage.success(`模拟支付完成，支付状态：${status.status}`)}await load()}finally{paying.value=false}}
async function getContent(){content.value=await digitalContent(order.value.orderNo);ElMessage.success('已获取数字内容授权链接')}
async function submitRefund(){
  if(!refundForm.reason.trim())return ElMessage.warning('请填写退款原因');
  // 已发货实物订单（状态 4）：退货物流公司与单号必填，随申请一并提交
  const shipped=Number(order.value.status)===4;
  if(shipped&&(!refundForm.returnCarrier.trim()||!refundForm.returnTrackingNo.trim()))return ElMessage.warning('已发货订单申请退款时必须填写退货物流公司和物流单号');
  refundBusy.value=true;
  try{
    await applyRefundApi({orderId:order.value.id,reason:refundForm.reason.trim(),description:refundForm.description.trim()||null,images:[],
      ...(shipped?{returnCarrier:refundForm.returnCarrier.trim(),returnTrackingNo:refundForm.returnTrackingNo.trim()}:{})});
    refundOpen.value=false;refundForm.reason='';refundForm.description='';refundForm.returnCarrier='';refundForm.returnTrackingNo='';
    ElMessage.success('退款申请已提交，等待管理员审核（本页已同步退款进度）');
    await load()
  }catch(e){/* 失败原因由全局拦截器 toast */}finally{refundBusy.value=false}
}
onMounted(load);watch(()=>route.params.id,load);onBeforeUnmount(()=>{if(stopPayPolling)stopPayPolling();if(drawPollTimer)clearInterval(drawPollTimer)})
</script>
<template><PageTitle eyebrow="ORDER DETAIL" title="订单详情"/><div v-loading="loading" class="content-card" v-if="order"><el-descriptions :column="2" border><el-descriptions-item label="订单编号">{{order.orderNo}}</el-descriptions-item><el-descriptions-item label="订单状态">{{order.statusText}}</el-descriptions-item><el-descriptions-item label="商品">{{itemCount>1?`${order.albumTitle} 等 ${itemCount} 件商品`:(order.albumTitle||'—')}}</el-descriptions-item><el-descriptions-item label="商品形态">{{order.productType}}</el-descriptions-item><el-descriptions-item label="数量">{{itemCount>1?totalQuantity:order.quantity}}</el-descriptions-item><el-descriptions-item label="金额">¥ {{order.totalAmount}}</el-descriptions-item><el-descriptions-item label="收货人">{{order.receiverName||'数字内容订单'}}</el-descriptions-item><el-descriptions-item label="联系电话">{{order.receiverPhone||'—'}}</el-descriptions-item><el-descriptions-item label="收货地址" :span="2">{{order.receiverAddress||'—'}}</el-descriptions-item><el-descriptions-item label="物流" :span="2"><span v-if="order.carrier">{{order.carrier}} <span class="mono">{{order.trackingNo}}</span><el-button v-if="[4,2].includes(Number(order.status))" text size="small" type="primary" @click="trackOpen=true">查看物流轨迹</el-button></span><span v-else>暂无物流信息</span></el-descriptions-item></el-descriptions><section v-if="order.items?.length" class="content-card" style="margin-top:20px"><div class="section-head"><h3>订单明细</h3><span class="muted">共 {{itemCount}} 项商品</span></div><el-table :data="order.items"><el-table-column label="商品" min-width="240"><template #default="{row}"><div class="detail-item"><img v-if="row.albumCover" :src="row.albumCover" width="48" height="48" style="object-fit:cover;border-radius:6px" alt=""/><span>{{row.albumTitle}}</span></div></template></el-table-column><el-table-column label="单价" width="110"><template #default="{row}">¥ {{row.price}}</template></el-table-column><el-table-column label="数量" width="80"><template #default="{row}">{{row.quantity}}</template></el-table-column><el-table-column label="小计" width="110"><template #default="{row}">¥ {{row.subtotal}}</template></el-table-column><el-table-column label="形态" width="100"><template #default="{row}">{{row.productTypeText||row.productType}}</template></el-table-column></el-table></section><BlindboxReveal v-if="showReveal" :order-no="order.orderNo" :summary="order.drawSummary" style="margin-top:20px"/><el-alert v-if="drawPending" title="支付成功，系统正在抽取奖品…" description="抽取完成后本页自动展示开箱结果" type="info" :closable="false" show-icon style="margin-top:20px"/><el-alert v-if="drawFailed" title="盲盒抽取失败，已自动原路退款" :description="order.drawSummary" type="warning" :closable="false" show-icon style="margin-top:20px"/><div class="actions" style="margin-top:20px"><el-button v-if="Number(order.status)===0" type="primary" :loading="paying" @click="pay">立即支付</el-button><el-button v-if="Number(order.status)===0&&order.productType!=='DIGITAL'" @click="addrOpen=true">修改地址</el-button><el-button v-if="order.productType==='DIGITAL'&&[1,2].includes(Number(order.status))" type="primary" @click="getContent">获取数字内容</el-button><el-button v-if="canApplyRefund" @click="refundOpen=true">申请退款</el-button></div><el-alert v-if="refundState&&refundState.text" :title="refundState.text" :description="Number(latestRefund.status)===2&&latestRefund.auditRemark?`拒绝原因：${latestRefund.auditRemark}，可重新申请`:null" :type="refundState.type==='info'?'warning':refundState.type" :closable="false" show-icon style="margin-top:16px"/><p v-if="content" class="content-card">{{content}}</p><el-dialog v-model="refundOpen" title="申请退款" width="min(560px,92vw)"><el-form label-position="top" @submit.prevent><el-form-item label="退款原因"><el-input v-model="refundForm.reason" maxlength="100" show-word-limit placeholder="简要说明退款原因"/></el-form-item><el-form-item label="详细说明"><el-input v-model="refundForm.description" type="textarea" maxlength="500" :rows="3" placeholder="补充说明（可选）"/></el-form-item><template v-if="Number(order.status)===4"><el-divider content-position="left">退货物流（已发货订单必填）</el-divider><el-form-item label="退货物流公司"><el-input v-model="refundForm.returnCarrier" maxlength="100" placeholder="如：顺丰速运"/></el-form-item><el-form-item label="退货物流单号"><el-input v-model="refundForm.returnTrackingNo" maxlength="100" placeholder="退货包裹的快递单号"/></el-form-item></template></el-form><template #footer><el-button @click="refundOpen=false">取消</el-button><el-button type="primary" :loading="refundBusy" @click="submitRefund">{{refundBusy?'提交中…':'提交申请'}}</el-button></template></el-dialog><OrderAddressDialog v-model="addrOpen" :order-no="order.orderNo" @saved="load"/><LogisticsTrackDialog v-model="trackOpen" :order-no="order.orderNo"/></div></template>

<style scoped>
.mono { font-family: var(--mono, monospace); }
.detail-item { display: flex; align-items: center; gap: 10px; }
</style>
