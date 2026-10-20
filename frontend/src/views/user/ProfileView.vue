<script setup>
import { onMounted, ref } from 'vue'
import { userInfo } from '../../api/auth'
import { useUserStore } from '../../stores/user'
import PageTitle from '../../components/PageTitle.vue'
const store=useUserStore(),profile=ref(store.user),loading=ref(false)
async function load(){loading.value=true;try{profile.value=await store.refreshUser()}finally{loading.value=false}}
onMounted(load)
</script>
<template><PageTitle eyebrow="YOUR ACCOUNT" title="个人中心" description="当前后端提供用户信息查询，资料编辑接口尚未实现。"/><div v-loading="loading" class="content-card" v-if="profile"><el-descriptions :column="1" border><el-descriptions-item label="用户编号">{{profile.id}}</el-descriptions-item><el-descriptions-item label="用户名">{{profile.username}}</el-descriptions-item><el-descriptions-item label="昵称">{{profile.nickname||'—'}}</el-descriptions-item><el-descriptions-item label="手机">{{profile.phone||'—'}}</el-descriptions-item><el-descriptions-item label="邮箱">{{profile.email||'—'}}</el-descriptions-item><el-descriptions-item label="角色"><el-tag>{{profile.role}}</el-tag></el-descriptions-item><el-descriptions-item label="注册时间">{{profile.createTime||'—'}}</el-descriptions-item></el-descriptions><div class="actions" style="margin-top:20px"><RouterLink to="/addresses"><el-button>收货地址</el-button></RouterLink><RouterLink to="/orders"><el-button>我的订单</el-button></RouterLink><RouterLink to="/refunds"><el-button>退款记录</el-button></RouterLink></div></div></template>
