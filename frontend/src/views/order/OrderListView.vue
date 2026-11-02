<script setup>
import { onBeforeUnmount, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { orders, cancelOrder, confirmReceipt, createPayment, queryPayment, mockPay } from '../../api/order'
import { startPayPolling } from '../../utils/payPolling'
import { confirmAction } from '../../utils/confirm'
import PageTitle from '../../components/PageTitle.vue'
const rows=ref([]),loading=ref(false),page=ref(1),total=ref(0)
let stopPayPolling=null
async function load(){loading.value=true;try{const p=await orders({current:page.value,size:10});rows.value=p?.records||[];total.value=Number(p?.total||0)}finally{loading.value=false}}
async function pay(row){const result=await createPayment({orderId:row.id});if(result.payUrl){window.open(result.payUrl,'_blank','noopener');ElMessage.info('已打开支付宝收银台，支付完成后列表自动更新');if(stopPayPolling)stopPayPolling();stopPayPolling=startPayPolling(result.paymentNo,{expireTime:result.expireTime,onPaid:()=>{ElMessage.success('支付成功');load()},onClosed:()=>{ElMessage.warning('支付单已关闭，如已完成付款请稍后刷新查看');load()}})}else if(result.paymentNo){await mockPay(result.paymentNo);const status=await queryPayment(result.paymentNo);ElMessage.success(`模拟支付完成，支付状态：${status.status}`)}await load()}
async function cancel(row){if(!(await confirmAction('取消后库存将立即回补，确定取消该订单？',{title:'取消订单',confirmText:'取消订单',cancelText:'保留订单'})))return;await cancelOrder(row.orderNo);ElMessage.success('订单已取消');load()}
async function receive(row){if(!(await confirmAction('确认已收到商品？确认后订单将完成。',{title:'确认收货',confirmText:'确认收货'})))return;await confirmReceipt(row.orderNo);ElMessage.success('已确认收货');load()}
onMounted(load);onBeforeUnmount(()=>{if(stopPayPolling)stopPayPolling()})
</script>
<template><PageTitle eyebrow="ORDERS" title="我的订单"/><el-table v-loading="loading" :data="rows"><el-table-column prop="orderNo" label="订单号" min-width="190"/><el-table-column prop="albumTitle" label="商品" min-width="160"/><el-table-column prop="quantity" label="数量" width="80"/><el-table-column prop="totalAmount" label="金额" width="110"/><el-table-column prop="statusText" label="状态" width="120"/><el-table-column label="操作" min-width="230"><template #default="{row}"><div class="actions"><RouterLink :to="`/orders/${encodeURIComponent(row.orderNo)}`"><el-button text>详情</el-button></RouterLink><el-button v-if="Number(row.status)===0" type="primary" text @click="pay(row)">支付</el-button><el-button v-if="Number(row.status)===0" type="danger" text @click="cancel(row)">取消</el-button><el-button v-if="Number(row.status)===4" type="primary" text @click="receive(row)">确认收货</el-button></div></template></el-table-column></el-table><div class="pagination"><el-pagination v-model:current-page="page" :page-size="10" :total="total" layout="prev,pager,next" @current-change="load"/></div></template>
