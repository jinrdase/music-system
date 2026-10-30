<script setup>
import PageTitle from '../../components/PageTitle.vue'
import MediaUploader from '../../components/MediaUploader.vue'
import { useUserStore } from '../../stores/user'
const user=useUserStore()
</script>
<template><div class="admin-page"><PageTitle eyebrow="CONTROL ROOM" title="管理概览" description="运营统计接口当前未提供。"/><div class="stat-grid"><div class="stat-card"><span class="muted">当前管理员</span><strong>{{user.user?.nickname||user.user?.username}}</strong></div><div class="stat-card"><span class="muted">权限角色</span><strong>{{user.user?.role}}</strong></div><div class="stat-card"><span class="muted">商品管理</span><strong>已连接</strong></div></div><section class="content-card" style="margin-top:24px"><h2>快捷入口</h2><div class="actions"><RouterLink to="/admin/albums"><el-button>专辑</el-button></RouterLink><RouterLink to="/admin/songs"><el-button>歌曲</el-button></RouterLink><RouterLink to="/admin/blindboxes"><el-button>盲盒</el-button></RouterLink><RouterLink to="/admin/users"><el-button>用户</el-button></RouterLink><RouterLink to="/admin/orders"><el-button>订单与退款</el-button></RouterLink></div></section><MediaUploader kind="image"/><MediaUploader kind="audio"/></div></template>
