<script setup>
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'
const user = useUserStore(); const router = useRouter()
function logout(){ user.logout(); router.push('/login') }
</script>
<template><header class="site-header"><RouterLink to="/" class="brand"><span class="brand-mark">◉</span> 潮汐唱片</RouterLink><nav><RouterLink to="/">发现</RouterLink><RouterLink to="/blindboxes">盲盒</RouterLink><RouterLink v-if="user.isLoggedIn" to="/orders">我的订单</RouterLink><RouterLink v-if="user.isAdmin" to="/admin">管理后台</RouterLink></nav><div class="header-actions"><RouterLink v-if="user.isLoggedIn" to="/cart" class="header-cart">购物袋</RouterLink><RouterLink v-if="user.isLoggedIn" to="/profile">{{user.user?.nickname || user.user?.username || '个人中心'}}</RouterLink><el-button v-if="user.isLoggedIn" text @click="logout">退出</el-button><RouterLink v-else to="/login" class="login-link">登录 / 注册</RouterLink></div></header></template>
