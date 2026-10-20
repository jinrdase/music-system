<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { adminUsers, userStatus, userRole } from '../../api/admin'
import PageTitle from '../../components/PageTitle.vue'
const rows=ref([]),loading=ref(false),keyword=ref(''),page=ref(1),total=ref(0)
async function load(){loading.value=true;try{const p=await adminUsers({current:page.value,size:10,keyword:keyword.value||undefined});rows.value=p?.records||[];total.value=Number(p?.total||0)}finally{loading.value=false}}
async function status(row){await userStatus(row.id,Number(row.status)===1?0:1);ElMessage.success('用户状态已更新');load()}
async function role(row){const {value}=await ElMessageBox.prompt('角色只能是 user、admin、super_admin','调整用户角色',{inputValue:row.role||'user'});if(!['user','admin','super_admin'].includes(value))return ElMessage.error('角色值无效');await userRole(row.id,value);ElMessage.success('角色已更新');load()}
onMounted(load)
</script>
<template><div class="admin-page"><PageTitle eyebrow="ACCOUNTS" title="用户管理"/><div class="toolbar"><el-input v-model="keyword" placeholder="用户名或关键词" clearable style="max-width:300px" @keyup.enter="page=1;load()"/><el-button @click="page=1;load()">搜索</el-button></div><el-table v-loading="loading" :data="rows"><el-table-column prop="id" label="ID" width="80"/><el-table-column prop="username" label="用户名"/><el-table-column prop="nickname" label="昵称"/><el-table-column prop="phone" label="手机号"/><el-table-column prop="role" label="角色" width="130"/><el-table-column prop="status" label="状态" width="100"><template #default="{row}">{{Number(row.status)===1?'正常':'禁用'}}</template></el-table-column><el-table-column label="操作" width="180"><template #default="{row}"><el-button text @click="status(row)">{{Number(row.status)===1?'禁用':'启用'}}</el-button><el-button text @click="role(row)">调整角色</el-button></template></el-table-column></el-table><div class="pagination"><el-pagination v-model:current-page="page" :page-size="10" :total="total" layout="prev,pager,next" @current-change="load"/></div></div></template>
