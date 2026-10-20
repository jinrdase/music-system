<script setup>
import { Loading } from '@element-plus/icons-vue'
defineProps({ loading: Boolean, empty: Boolean, text: { type: String, default: '暂无数据' } })
</script>
<template><div v-if="loading" class="state-box"><el-icon class="is-loading"><Loading/></el-icon> 正在加载…</div><el-empty v-else-if="empty" :description="text"/><slot v-else/></template>
