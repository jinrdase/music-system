<script setup>
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { logisticsTrack } from '../api/order'

const props = defineProps({
  orderNo: { type: String, default: '' },
  modelValue: Boolean,
})
const emit = defineEmits(['update:modelValue'])

const open = ref(props.modelValue)
const loading = ref(false)
const track = ref(null)
const errorMsg = ref('')

watch(() => props.modelValue, async visible => {
  open.value = visible
  if (!visible) return
  track.value = null
  errorMsg.value = ''
  loading.value = true
  try {
    track.value = await logisticsTrack(props.orderNo)
  } catch (error) {
    errorMsg.value = error.message || '物流查询失败，请稍后重试'
  } finally {
    loading.value = false
  }
})
watch(open, value => { if (!value) emit('update:modelValue', false) })

async function copyTrackingNo() {
  try {
    await navigator.clipboard.writeText(track.value.trackingNo)
    ElMessage.success('单号已复制')
  } catch {
    ElMessage.error('复制失败，请手动选择单号复制')
  }
}
</script>

<template>
  <el-dialog v-model="open" title="物流信息" width="min(560px,92vw)">
    <div v-loading="loading" class="track-body">
      <template v-if="track">
        <div class="track-head">
          <div class="track-row"><span class="label">承运商</span><span>{{ track.carrier || '—' }}</span></div>
          <div class="track-row">
            <span class="label">快递单号</span>
            <span class="mono">{{ track.trackingNo || '—' }}</span>
            <el-button v-if="track.trackingNo" text size="small" type="primary" @click="copyTrackingNo">复制</el-button>
          </div>
          <div class="track-row"><span class="label">发货时间</span><span>{{ track.shippedAt || '—' }}</span></div>
          <div v-if="track.trackEnabled && track.stateText" class="track-row">
            <span class="label">当前状态</span>
            <el-tag size="small" :type="Number(track.state) === 3 ? 'success' : 'warning'">{{ track.stateText }}</el-tag>
          </div>
        </div>

        <el-alert
          v-if="!track.trackEnabled"
          title="物流轨迹查询服务未开启，可复制单号到承运商官网查询"
          type="info" :closable="false" show-icon style="margin-top:14px"/>

        <el-timeline v-else-if="track.tracks && track.tracks.length" style="margin-top:18px">
          <el-timeline-item
            v-for="(node, index) in track.tracks"
            :key="index"
            :timestamp="node.time"
            :type="index === 0 ? 'primary' : undefined"
            :hollow="index !== 0">
            <div class="track-context">{{ node.context }}</div>
            <div v-if="node.location" class="track-location">{{ node.location }}</div>
          </el-timeline-item>
        </el-timeline>
        <el-empty v-else-if="track.trackEnabled" description="暂无轨迹明细"/>
      </template>
      <el-alert v-else-if="errorMsg" :title="errorMsg" type="warning" :closable="false" show-icon/>
    </div>
    <template #footer>
      <el-button @click="open = false">关闭</el-button>
    </template>
  </el-dialog>
</template>

<style scoped>
.track-body { min-height: 120px; }
.track-head { display: flex; flex-direction: column; gap: 6px; }
.track-row { display: flex; align-items: center; gap: 8px; font-size: 13.5px; }
.track-row .label { color: var(--muted, #94a1ad); width: 64px; flex: none; }
.mono { font-family: var(--mono, monospace); }
.track-context { font-size: 13.5px; line-height: 1.6; }
.track-location { font-size: 12px; color: var(--muted, #94a1ad); margin-top: 2px; }
</style>
