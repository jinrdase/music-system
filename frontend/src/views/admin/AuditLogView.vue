<script setup>
import { onMounted, ref } from 'vue'
import { auditLogs } from '../../api/admin'
import { useUserStore } from '../../stores/user'
import PageTitle from '../../components/PageTitle.vue'
const user=useUserStore(),rows=ref([]),loading=ref(false),current=ref(1),total=ref(0)
async function load(){loading.value=true;try{const p=await auditLogs({current:current.value,size:20});rows.value=p?.records||[];total.value=Number(p?.total||0)}finally{loading.value=false}}
onMounted(()=>{if(user.user?.role==='super_admin')load()})
</script>
<template><div class="admin-page"><PageTitle eyebrow="AUDIT TRAIL" title="操作审计" description="该接口由后端限制为 super_admin。"/><el-alert v-if="user.user?.role!=='super_admin'" type="warning" :closable="false" title="只有超级管理员可以查看审计日志。"/><template v-else><el-table v-loading="loading" :data="rows"><el-table-column prop="createdAt" label="时间" min-width="180"/><el-table-column prop="operatorUserId" label="操作人 ID" width="110"/><el-table-column prop="operatorRole" label="角色" width="130"/><el-table-column prop="httpMethod" label="方法" width="90"/><el-table-column prop="requestPath" label="请求路径" min-width="240"/><el-table-column prop="responseStatus" label="状态码" width="100"/><el-table-column prop="clientIp" label="IP" width="140"/></el-table><div class="pagination"><el-pagination v-model:current-page="current" :page-size="20" :total="total" layout="prev,pager,next" @current-change="load"/></div></template></div></template>
