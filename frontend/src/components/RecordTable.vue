<script setup>
defineProps({ rows: { type: Array, default: () => [] }, columns: { type: Array, default: () => [] }, loading: Boolean })
</script>
<template><el-table :data="rows" v-loading="loading" stripe><el-table-column v-for="col in columns" :key="col.key" :prop="col.key" :label="col.label" :min-width="col.width || 120" show-overflow-tooltip/><el-table-column v-if="$attrs.actions" label="操作" width="180"><template #default="{row}"><slot name="actions" :row="row"/></template></el-table-column><template #empty><el-empty description="暂无数据"/></template></el-table></template>
