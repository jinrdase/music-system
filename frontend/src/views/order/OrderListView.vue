<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { orders, cancelOrder, confirmReceipt, createPayment, queryPayment } from '../../api/order'
import PageTitle from '../../components/PageTitle.vue'
const rows=ref([]),loading=ref(false),page=ref(1),total=ref(0)
async function load(){loading.value=true;try{const p=await orders({current:page.value,size:10});rows.value=p?.records||[];total.value=Number(p?.total||0)}finally{loading.value=false}}
async function pay(row){const {value:method}=await ElMessageBox.prompt('选择支付方式：1 微信，2 支付宝，3 余额','创建支付',{inputValue:'1',inputPattern:/^[123]$/});const result=await createPayment({orderId:row.id,paymentMethod:Number(method)});ElMessage.info(`支付单 ${result.paymentNo||''} 已创建；当前后端为模拟支付，请使用状态查询。`);if(result.paymentNo){const status=await queryPayment(result.paymentNo);ElMessage.info(`当前支付状态：${status.status}`)}await load()}
async function cancel(row){await ElMessageBox.confirm('确认取消未支付订单？');await cancelOrder(row.orderNo);ElMessage.success('订单已取消');load()}
async function receive(row){await ElMessageBox.confirm('确认已收到商品？');await confirmReceipt(row.orderNo);ElMessage.success('已确认收货');load()}
onMounted(load)
</script>
<template><PageTitle eyebrow="ORDERS" title="我的订单"/><el-table v-loading="loading" :data="rows"><el-table-column prop="orderNo" label="订单号" min-width="190"/><el-table-column prop="albumTitle" label="商品" min-width="160"/><el-table-column prop="quantity" label="数量" width="80"/><el-table-column prop="totalAmount" label="金额" width="110"/><el-table-column prop="statusText" label="状态" width="120"/><el-table-column label="操作" min-width="230"><template #default="{row}"><div class="actions"><RouterLink :to="`/orders/${encodeURIComponent(row.orderNo)}`"><el-button text>详情</el-button></RouterLink><el-button v-if="Number(row.status)===0" type="primary" text @click="pay(row)">支付</el-button><el-button v-if="Number(row.status)===0" type="danger" text @click="cancel(row)">取消</el-button><el-button v-if="Number(row.status)===4" type="primary" text @click="receive(row)">确认收货</el-button></div></template></el-table-column></el-table><div class="pagination"><el-pagination v-model:current-page="page" :page-size="10" :total="total" layout="prev,pager,next" @current-change="load"/></div></template>
