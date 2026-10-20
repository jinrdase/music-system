<script setup>
import { onMounted, ref } from 'vue'
import { myRefunds } from '../../api/order'
import PageTitle from '../../components/PageTitle.vue'
const rows=ref([]),loading=ref(false),page=ref(1),total=ref(0)
async function load(){loading.value=true;try{const p=await myRefunds({current:page.value,size:10});rows.value=p?.records||[];total.value=Number(p?.total||0)}finally{loading.value=false}}
onMounted(load)
</script>
<template><PageTitle eyebrow="REFUNDS" title="退款申请" description="退款发起入口在订单详情对应的订单状态下提供。"/><el-table v-loading="loading" :data="rows"><el-table-column prop="id" label="申请编号" width="100"/><el-table-column prop="orderNo" label="订单号" min-width="180"/><el-table-column prop="reason" label="退款原因" min-width="180"/><el-table-column prop="status" label="状态" width="100"/><el-table-column prop="createTime" label="申请时间" min-width="180"/><el-table-column prop="auditRemark" label="审核说明" min-width="180"/></el-table><div class="pagination"><el-pagination v-model:current-page="page" :page-size="10" :total="total" layout="prev,pager,next" @current-change="load"/></div></template>
