<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { pendingRefunds, reviewRefund, shipOrder } from '../../api/admin'
import PageTitle from '../../components/PageTitle.vue'
const rows=ref([]),loading=ref(false),current=ref(1),total=ref(0),orderNo=ref(''),carrier=ref(''),trackingNo=ref('')
async function load(){loading.value=true;try{const p=await pendingRefunds({current:current.value,size:10});rows.value=p?.records||[];total.value=Number(p?.total||0)}finally{loading.value=false}}
async function review(row,approved){let auditRemark='';if(!approved){const value=window.prompt('请填写拒绝原因');if(!value?.trim())return;auditRemark=value}else auditRemark=window.prompt('审核备注（选填）')||'';await reviewRefund(row.id,{approved,auditRemark});ElMessage.success('退款申请已审核');load()}
async function ship(){if(!orderNo.value||!carrier.value||!trackingNo.value)return ElMessage.warning('请填写订单号、物流公司和物流单号');await shipOrder(orderNo.value,{carrier:carrier.value,trackingNo:trackingNo.value});ElMessage.success('已登记发货信息');orderNo.value='';carrier.value='';trackingNo.value=''}
onMounted(load)
</script>
<template><div class="admin-page"><PageTitle eyebrow="FULFILLMENT" title="订单与退款" description="后端没有管理员订单列表接口；可以按订单号登记发货，并审核退款申请。"/><section class="content-card"><h2>登记发货</h2><div class="toolbar"><el-input v-model="orderNo" placeholder="订单号"/><el-input v-model="carrier" placeholder="物流公司"/><el-input v-model="trackingNo" placeholder="物流单号"/><el-button type="primary" @click="ship">提交发货信息</el-button></div></section><section class="content-card"><h2>待审核退款</h2><el-table v-loading="loading" :data="rows"><el-table-column prop="id" label="申请 ID" width="90"/><el-table-column prop="orderNo" label="订单号" min-width="180"/><el-table-column prop="reason" label="原因"/><el-table-column prop="description" label="说明"/><el-table-column label="操作" width="170"><template #default="{row}"><el-button type="success" text @click="review(row,true)">通过</el-button><el-button type="danger" text @click="review(row,false)">拒绝</el-button></template></el-table-column></el-table><div class="pagination"><el-pagination v-model:current-page="current" :page-size="10" :total="total" layout="prev,pager,next" @current-change="load"/></div></section></div></template>
