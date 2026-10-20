<script setup>
import { useUserStore } from '../stores/user'
const user = useUserStore()
const links = [['/admin','概览'],['/admin/albums','专辑管理'],['/admin/songs','歌曲管理'],['/admin/blindboxes','盲盒管理'],['/admin/users','用户管理'],['/admin/orders','订单与退款'],['/admin/audit-logs','操作审计']]
</script>
<template><div class="admin-shell"><aside class="admin-sidebar"><RouterLink to="/" class="brand">潮汐<span> / 控制台</span></RouterLink><p class="muted">后台管理</p><RouterLink v-for="[to,label] in links" :key="to" :to="to" class="side-link">{{label}}</RouterLink><el-button class="logout" text @click="user.logout();$router.push('/login')">退出登录</el-button></aside><main class="admin-main"><header class="admin-top"><span>欢迎，{{user.user?.nickname || user.user?.username}}</span><RouterLink to="/">返回商店 ↗</RouterLink></header><RouterView/></main></div></template>
