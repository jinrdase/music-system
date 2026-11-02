<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { adminAuditLogs } from '../../api/admin'
import PageTitle from '../../components/PageTitle.vue'

const rows = ref([])
const loading = ref(false)
const current = ref(1)
const total = ref(0)
const operatorUserId = ref('')
const httpMethod = ref('')
const requestPath = ref('')
const range = ref([])

async function load() {
  loading.value = true
  try {
    const params = { current: current.value, size: 20 }
    if (operatorUserId.value) params.operatorUserId = Number(operatorUserId.value)
    if (httpMethod.value) params.httpMethod = httpMethod.value
    if (requestPath.value.trim()) params.requestPath = requestPath.value.trim()
    if (range.value?.[0]) params.from = range.value[0]
    if (range.value?.[1]) params.to = range.value[1]
    const page = await adminAuditLogs(params)
    rows.value = page?.records || []
    total.value = Number(page?.total || 0)
  } catch (error) {
    rows.value = []
    total.value = 0
    if (error.code === 500 || error.message?.includes('admin_audit_log')) {
      ElMessage.warning('审计日志表尚未安装，请先执行 sql/20261101_admin_audit_log.sql')
    }
  } finally {
    loading.value = false
  }
}

function filter() { current.value = 1; load() }
onMounted(load)
</script>

<template>
  <PageTitle eyebrow="AUDIT TRAIL" title="操作审计" description="查询管理员接口访问记录。审计表迁移执行前，页面会提示数据表不可用。" />
  <section class="content-card">
    <div class="toolbar">
      <el-input v-model="operatorUserId" clearable placeholder="操作人用户 ID" />
      <el-select v-model="httpMethod" clearable placeholder="请求方法">
        <el-option label="GET" value="GET" /><el-option label="POST" value="POST" />
        <el-option label="PUT" value="PUT" /><el-option label="DELETE" value="DELETE" />
      </el-select>
      <el-input v-model="requestPath" clearable placeholder="请求路径包含" />
      <el-date-picker v-model="range" type="datetimerange" value-format="YYYY-MM-DDTHH:mm:ss" start-placeholder="开始时间" end-placeholder="结束时间" />
      <el-button type="primary" :loading="loading" @click="filter">筛选</el-button>
      <el-button :disabled="loading" @click="load">刷新</el-button>
    </div>
    <el-empty v-if="!loading && rows.length === 0" description="暂无审计记录，或审计表迁移尚未执行。" />
    <el-table v-else v-loading="loading" :data="rows" row-key="id">
      <el-table-column prop="createdAt" label="时间" min-width="175" />
      <el-table-column prop="operatorUserId" label="操作人 ID" width="110" />
      <el-table-column prop="operatorRole" label="角色" width="120" />
      <el-table-column prop="httpMethod" label="方法" width="100" />
      <el-table-column prop="requestPath" label="请求路径" min-width="250" show-overflow-tooltip />
      <el-table-column prop="responseStatus" label="HTTP 状态" width="110" />
      <el-table-column prop="clientIp" label="客户端地址" min-width="150" />
    </el-table>
    <div class="pagination"><el-pagination v-model:current-page="current" :page-size="20" :total="total" layout="prev, pager, next, total" @current-change="load" /></div>
  </section>
</template>
