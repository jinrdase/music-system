<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { orderDetail, digitalContent, applyRefund as applyRefundApi, myRefunds, confirmReceipt } from '../../api/order'
import PageTitle from '../../components/PageTitle.vue'
import PaymentDialog from '../../components/PaymentDialog.vue'
import DrawAnimation from '../../components/DrawAnimation.vue'
import { orderDrawRecords } from '../../api/blindbox'

const route = useRoute()
const router = useRouter()
const order = ref(null)
const loading = ref(false)
const payOpen = ref(false)
const content = ref('')
const refundOpen = ref(false)
const refundBusy = ref(false)
const refundForm = reactive({ reason: '', description: '', returnCarrier: '', returnTrackingNo: '' })
const drawRecords = ref([])
const drawOpen = ref(false)
const carrierOptions = ['顺丰速运', '中通快递', '圆通速递', '韵达快递', '申通快递', '极兔速递', '京东物流', '邮政EMS']
const reasonOptions = ['不想要了', '商品与描述不符', '商品破损/有瑕疵', '物流太慢', '拍错了/重复下单', '其他原因']

const REFUND_STATUS_TEXT = { 0: '审核中', 1: '已通过', 2: '已驳回', 3: '已退款' }

async function load() {
  loading.value = true
  try {
    order.value = await orderDetail(route.params.id)
    // 旧版本后端未在详情中返回退款状态时，从退款记录里回填，保证按钮与状态一致
    if (order.value && order.value.refundStatus === undefined) {
      try {
        const page = await myRefunds({ current: 1, size: 50 })
        const record = (page?.records || []).find(item => String(item.orderNo) === String(order.value.orderNo))
        if (record) {
          order.value.refundStatus = record.status
          order.value.refundStatusText = REFUND_STATUS_TEXT[Number(record.status)] || ''
          order.value.refundReason = record.reason
        }
      } catch { /* 退款记录加载失败不影响详情展示 */ }
    }
  } finally {
    loading.value = false
  }
}

// 后端未返回判定字段时（旧版本后端）在前端做同样的兜底判断
const hasRefund = computed(() => {
  const s = order.value?.refundStatus
  return s !== null && s !== undefined && s !== ''
})
const canApplyRefund = computed(() => {
  const o = order.value
  if (!o) return false
  if (typeof o.canApplyRefund === 'boolean') return o.canApplyRefund
  const status = Number(o.status)
  if (hasRefund.value && [0, 1, 3].includes(Number(o.refundStatus))) return false
  if (String(o.productType).toUpperCase() === 'DIGITAL') return status === 1
  return status === 1 || status === 4
})
const requiresReturnShipping = computed(() => {
  const o = order.value
  if (!o) return false
  if (typeof o.requiresReturnShipping === 'boolean') return o.requiresReturnShipping
  return String(o.productType).toUpperCase() === 'PHYSICAL' && Number(o.status) === 4
})
// refundStatus 为 null 时 Number(null) 会变成 0，必须显式排除空值，否则新订单会误显示“审核中”
const refundActive = computed(() => hasRefund.value && [0, 1].includes(Number(order.value.refundStatus)))
const refundStatusTag = computed(() => {
  const map = { 0: 'warning', 1: 'primary', 2: 'danger', 3: 'success' }
  return map[Number(order.value?.refundStatus)] || 'info'
})

function openRefund() {
  refundForm.reason = ''
  refundForm.description = ''
  refundForm.returnCarrier = order.value?.carrier || carrierOptions[0]
  refundForm.returnTrackingNo = ''
  refundOpen.value = true
}

async function pay() {
  if (!order.value || Number(order.value.status) !== 0) return
  payOpen.value = true
}

async function getContent() {
  content.value = await digitalContent(order.value.orderNo)
  ElMessage.success('已获取数字内容授权链接')
}

async function submitRefund() {
  if (refundBusy.value) return
  if (!refundForm.reason.trim()) return ElMessage.warning('请选择或填写退款原因')
  if (requiresReturnShipping.value) {
    if (!refundForm.returnCarrier.trim()) return ElMessage.warning('请选择退货物流公司')
    if (!refundForm.returnTrackingNo.trim()) return ElMessage.warning('请填写退货物流单号')
  }
  refundBusy.value = true
  try {
    await applyRefundApi({
      orderId: order.value.id,
      reason: refundForm.reason.trim(),
      description: refundForm.description.trim() || null,
      images: [],
      returnCarrier: requiresReturnShipping.value ? refundForm.returnCarrier.trim() : null,
      returnTrackingNo: requiresReturnShipping.value ? refundForm.returnTrackingNo.trim() : null
    })
    refundOpen.value = false
    ElMessage.success('退款申请已提交，等待管理员审核')
    await load()
  } finally {
    refundBusy.value = false
  }
}

const isBlindBox = computed(() => !!order.value && (Number(order.value.orderType) === 2 || String(order.value.orderNo || '').startsWith('BB')))

async function loadDrawRecords() {
  if (!isBlindBox.value) { drawRecords.value = []; return }
  try {
    drawRecords.value = await orderDrawRecords(order.value.orderNo) || []
  } catch { drawRecords.value = [] }
}

// 支付成功后只刷新页面，抽取动画等用户“确认收货”后再播放
async function onPaid() {
  await load()
  await loadDrawRecords()
}

// 盲盒订单：确认收货即视为领取奖品，此时才播放抽取动画
const confirming = ref(false)
async function confirmReceive() {
  if (confirming.value) return
  confirming.value = true
  try {
    await confirmReceipt(order.value.orderNo)
    ElMessage.success('已确认收货')
    await load()
    await loadDrawRecords()
    if (drawRecords.value.length) drawOpen.value = true
  } finally {
    confirming.value = false
  }
}

onMounted(async () => { await load(); await loadDrawRecords() })
watch(() => route.params.id, async () => { await load(); await loadDrawRecords() })
</script>

<template>
  <PageTitle eyebrow="ORDER DETAIL" title="订单详情" />
  <div v-if="order" v-loading="loading" class="content-card">
    <el-descriptions :column="2" border>
      <el-descriptions-item label="订单编号">{{ order.orderNo }}</el-descriptions-item>
      <el-descriptions-item label="订单状态">{{ order.statusText }}</el-descriptions-item>
      <el-descriptions-item label="商品">{{ order.albumTitle }}</el-descriptions-item>
      <el-descriptions-item label="商品形态">{{ order.productType }}</el-descriptions-item>
      <el-descriptions-item label="数量">{{ order.quantity }}</el-descriptions-item>
      <el-descriptions-item label="金额">¥ {{ order.totalAmount }}</el-descriptions-item>
      <el-descriptions-item label="收货人">{{ order.receiverName || '数字内容订单' }}</el-descriptions-item>
      <el-descriptions-item label="联系电话">{{ order.receiverPhone || '—' }}</el-descriptions-item>
      <el-descriptions-item label="收货地址" :span="2">{{ order.receiverAddress || '—' }}</el-descriptions-item>
      <el-descriptions-item label="物流" :span="2">
        <template v-if="order.carrier">{{ order.carrier }} · {{ order.trackingNo || '—' }}</template>
        <template v-else>—</template>
      </el-descriptions-item>
      <el-descriptions-item v-if="order.refundStatus !== null && order.refundStatus !== undefined" label="退款" :span="2">
        <el-tag :type="refundStatusTag" size="small">{{ order.refundStatusText }}</el-tag>
        <span v-if="order.refundReason" class="muted" style="margin-left:8px">原因：{{ order.refundReason }}</span>
      </el-descriptions-item>
    </el-descriptions>

    <el-alert v-if="refundActive" type="warning" :closable="false" show-icon style="margin-top:16px"
      :title="Number(order.refundStatus) === 0 ? '退款申请审核中，请等待管理员处理' : '退款申请已通过，退款到账后订单将关闭'" />

    <div class="actions" style="margin-top:20px">
      <el-button v-if="Number(order.status) === 0" type="primary" @click="pay">立即支付</el-button>
      <el-button v-if="order.productType === 'DIGITAL' && [1, 2].includes(Number(order.status))" type="primary" @click="getContent">获取数字内容</el-button>
      <el-button v-if="isBlindBox && Number(order.status) === 1" type="primary" :loading="confirming" @click="confirmReceive">确认收货</el-button>
      <el-button v-if="drawRecords.length && Number(order.status) === 2" type="primary" plain @click="drawOpen = true">查看抽取动画</el-button>
      <el-button v-if="canApplyRefund" @click="openRefund">申请退款</el-button>
      <el-button v-if="order.refundStatus !== null && order.refundStatus !== undefined" text type="primary" @click="router.push('/refunds')">查看退款记录</el-button>
    </div>

    <p v-if="content" class="content-card" style="margin-top:16px">{{ content }}</p>
  </div>

  <el-dialog v-model="refundOpen" title="申请退款" width="min(520px,94vw)" align-center :close-on-click-modal="false">
    <div class="refund-summary">
      <div>
        <p class="eyebrow">退款金额</p>
        <strong>¥ {{ order?.totalAmount }}</strong>
      </div>
      <p class="muted">订单号 {{ order?.orderNo }}</p>
    </div>
    <el-form label-position="top">
      <el-form-item label="退款原因" required>
        <el-select v-model="refundForm.reason" filterable allow-create default-first-option placeholder="选择或输入退款原因" style="width:100%">
          <el-option v-for="item in reasonOptions" :key="item" :label="item" :value="item" />
        </el-select>
      </el-form-item>
      <el-form-item label="详细说明">
        <el-input v-model="refundForm.description" type="textarea" :rows="3" maxlength="500" show-word-limit placeholder="补充说明有助于加快审核（选填）" />
      </el-form-item>
      <template v-if="requiresReturnShipping">
        <el-alert type="info" :closable="false" show-icon style="margin-bottom:14px" title="该订单已发货，请退回商品并填写退货物流信息" />
        <el-form-item label="退货物流公司" required>
          <el-select v-model="refundForm.returnCarrier" filterable allow-create default-first-option placeholder="选择或输入物流公司" style="width:100%">
            <el-option v-for="item in carrierOptions" :key="item" :label="item" :value="item" />
          </el-select>
        </el-form-item>
        <el-form-item label="退货物流单号" required>
          <el-input v-model="refundForm.returnTrackingNo" maxlength="100" placeholder="例如：SF1234567890" />
        </el-form-item>
      </template>
    </el-form>
    <template #footer>
      <el-button @click="refundOpen = false">取消</el-button>
      <el-button type="primary" :loading="refundBusy" @click="submitRefund">提交申请</el-button>
    </template>
  </el-dialog>

  <PaymentDialog v-model="payOpen" :order="order" @paid="onPaid" />
  <DrawAnimation v-model="drawOpen" :records="drawRecords" :box-name="order?.albumTitle || ''" />
</template>

<style scoped>
.refund-summary { display: flex; align-items: center; justify-content: space-between; gap: 16px; padding: 14px 16px; margin-bottom: 18px; border-radius: 12px; background: rgba(128, 128, 128, 0.14); }
.refund-summary .eyebrow { margin: 0 0 4px; font-size: 12px; letter-spacing: .08em; color: var(--el-text-color-secondary, #909399); }
.refund-summary strong { font-size: 22px; }
.refund-summary .muted { margin: 0; font-size: 12px; color: var(--el-text-color-secondary, #909399); }
</style>
