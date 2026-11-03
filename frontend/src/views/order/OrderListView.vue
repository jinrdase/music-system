<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { orders, cancelOrder, confirmReceipt } from '../../api/order'
import PageTitle from '../../components/PageTitle.vue'
import PaymentDialog from '../../components/PaymentDialog.vue'
import DrawAnimation from '../../components/DrawAnimation.vue'
import { orderDrawRecords } from '../../api/blindbox'
const rows=ref([]),loading=ref(false),page=ref(1),total=ref(0)
const payOpen=ref(false),payOrder=ref(null)
const drawRecords=ref([]),drawOpen=ref(false)
async function load(){loading.value=true;try{const p=await orders({current:page.value,size:10});rows.value=p?.records||[];total.value=Number(p?.total||0)}finally{loading.value=false}}
function pay(row){payOrder.value=row;payOpen.value=true}
const isBlindBoxRow = row => String(row?.orderNo || '').startsWith('BB') || Number(row?.orderType) === 2
const drawBoxName=ref('')
// 支付成功只刷新列表；抽取动画等用户“确认收货”后再播放
async function onPaid(){await load()}
async function cancel(row){await ElMessageBox.confirm('确认取消未支付订单？');await cancelOrder(row.orderNo);ElMessage.success('订单已取消');load()}
// 确认收货：盲盒订单领取奖品，此时播放抽取动画
async function receive(row){
  const blindBox=isBlindBoxRow(row)
  await ElMessageBox.confirm(blindBox?'确认收下抽取的奖品？确认后将结束订单。':'确认已收到商品？')
  await confirmReceipt(row.orderNo)
  ElMessage.success('已确认收货')
  await load()
  if(!blindBox)return
  try{
    const rs=await orderDrawRecords(row.orderNo)
    if(rs&&rs.length){drawBoxName.value=row.albumTitle||'';drawRecords.value=rs;drawOpen.value=true}
  }catch{/* 忽略：动画回放失败不影响收货 */}
}
onMounted(load)
</script>
<template><PageTitle eyebrow="ORDERS" title="我的订单"/><el-table v-loading="loading" :data="rows"><el-table-column prop="orderNo" label="订单号" min-width="190"/><el-table-column prop="albumTitle" label="商品" min-width="160"/><el-table-column prop="quantity" label="数量" width="80"/><el-table-column prop="totalAmount" label="金额" width="110"/><el-table-column prop="statusText" label="状态" width="120"/><el-table-column label="操作" min-width="230"><template #default="{row}"><div class="actions"><RouterLink :to="`/orders/${encodeURIComponent(row.orderNo)}`"><el-button text>详情</el-button></RouterLink><el-button v-if="Number(row.status)===0" type="primary" text @click="pay(row)">支付</el-button><el-button v-if="Number(row.status)===0" type="danger" text @click="cancel(row)">取消</el-button><el-button v-if="Number(row.status)===4 || (isBlindBoxRow(row) && Number(row.status)===1)" type="primary" text @click="receive(row)">确认收货</el-button></div></template></el-table-column></el-table><div class="pagination"><el-pagination v-model:current-page="page" :page-size="10" :total="total" layout="prev,pager,next" @current-change="load"/></div><PaymentDialog v-model="payOpen" :order="payOrder" @paid="onPaid"/><DrawAnimation v-model="drawOpen" :records="drawRecords" :box-name="drawBoxName"/></template>
