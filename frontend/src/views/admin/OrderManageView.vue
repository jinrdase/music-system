<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElLoading, ElMessage } from 'element-plus'
import { adminOrders, pendingRefunds, reviewRefund, shipOrder } from '../../api/admin'
import PageTitle from '../../components/PageTitle.vue'

const rows = ref([])
const loading = ref(false)
const current = ref(1)
const total = ref(0)
const refunds = ref([])
const refundLoading = ref(false)
const refundTotal = ref(0)
const status = ref('')
const orderNo = ref('')
const userId = ref('')

const shipOpen = ref(false)
const shipSubmitting = ref(false)
const shipRow = ref(null)
const shipForm = reactive({ carrier: '', trackingNo: '' })
const carrierOptions = ['顺丰速运', '中通快递', '圆通速递', '韵达快递', '申通快递', '极兔速递', '京东物流', '邮政EMS']
const shipTitle = computed(() => Number(shipRow.value?.status) === 4 ? '修改物流信息' : '登记发货')
const isDigital = computed(() => String(shipRow.value?.productType || '').toUpperCase() === 'DIGITAL')

const reviewOpen = ref(false)
const reviewSubmitting = ref(false)
const reviewRow = ref(null)
const reviewApproved = ref(true)
const reviewRemark = ref('')
const reviewTitle = computed(() => reviewApproved.value ? '通过退款申请' : '拒绝退款申请')

async function load() {
  loading.value = true
  try {
    const p = await adminOrders({
      current: current.value,
      size: 10,
      status: status.value === '' ? undefined : Number(status.value),
      orderNo: orderNo.value || undefined,
      userId: userId.value ? Number(userId.value) : undefined
    })
    rows.value = p?.records || []
    total.value = Number(p?.total || 0)
  } finally {
    loading.value = false
  }
}

async function loadRefunds() {
  refundLoading.value = true
  try {
    // 一次拉取较全量并在前端按申请时间倒序，避免新申请被压在最后一页看不到
    const p = await pendingRefunds({ current: 1, size: 100 })
    const list = p?.records || []
    list.sort((a, b) => String(b.createTime || '').localeCompare(String(a.createTime || '')) || Number(b.id) - Number(a.id))
    refunds.value = list
    refundTotal.value = Number(p?.total || list.length)
  } finally {
    refundLoading.value = false
  }
}

function openReview(row, approved) {
  reviewRow.value = row
  reviewApproved.value = approved
  reviewRemark.value = ''
  reviewOpen.value = true
}

async function submitReview() {
  if (reviewSubmitting.value) return
  if (!reviewApproved.value && !reviewRemark.value.trim()) return ElMessage.warning('请填写拒绝原因')
  reviewSubmitting.value = true
  const approved = reviewApproved.value
  const target = reviewRow.value
  // 立即关闭弹窗，避免"点了没反应"的错觉；处理过程用全屏遮罩反馈
  reviewOpen.value = false
  const mask = ElLoading.service({
    lock: true,
    text: approved ? '正在执行退款，请稍候…' : '正在提交审核结果…',
    background: 'rgba(0, 0, 0, 0.55)'
  })
  try {
    await reviewRefund(target.id, { approved, auditRemark: reviewRemark.value.trim() })
    ElMessage.success(approved ? `已通过退款（订单 ${target.orderNo}），订单已置为已退款` : `已拒绝退款申请（订单 ${target.orderNo}）`)
  } catch {
    // 具体错误信息由请求拦截器统一提示，这里保持弹窗关闭并刷新列表反映真实状态
  } finally {
    mask.close()
    reviewSubmitting.value = false
    await loadRefunds()
    await load()
  }
}

function openShip(row) {
  shipRow.value = row
  shipForm.carrier = row.carrier || carrierOptions[0]
  shipForm.trackingNo = row.trackingNo || ''
  shipOpen.value = true
}

async function submitShip() {
  if (!shipForm.carrier.trim()) return ElMessage.warning('请选择或填写物流公司')
  if (!shipForm.trackingNo.trim()) return ElMessage.warning('请填写物流单号')
  shipSubmitting.value = true
  try {
    await shipOrder(shipRow.value.orderNo, { carrier: shipForm.carrier.trim(), trackingNo: shipForm.trackingNo.trim() })
    ElMessage.success(Number(shipRow.value.status) === 4 ? '物流信息已更新' : '已登记发货，用户订单详情可查看物流')
    shipOpen.value = false
    load()
  } finally {
    shipSubmitting.value = false
  }
}

onMounted(() => {
  load()
  loadRefunds()
})
</script>

<template>
  <div class="admin-page">
    <PageTitle eyebrow="FULFILLMENT" title="订单与退款" description="登记发货或修改物流后，用户订单详情会同步展示；用户提交的退款申请会出现在下方「待审核退款」中。" />

    <section class="content-card">
      <div class="toolbar">
        <el-input v-model="orderNo" placeholder="订单号" clearable />
        <el-input v-model="userId" placeholder="用户 ID" clearable />
        <el-select v-model="status" placeholder="全部状态" clearable>
          <el-option label="待支付" value="0" />
          <el-option label="已支付" value="1" />
          <el-option label="已完成" value="2" />
          <el-option label="已取消" value="3" />
          <el-option label="已发货" value="4" />
          <el-option label="已退款" value="5" />
        </el-select>
        <el-button type="primary" @click="current = 1; load()">筛选</el-button>
      </div>
      <el-table v-loading="loading" :data="rows">
        <el-table-column prop="orderNo" label="订单号" min-width="190" />
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="albumTitle" label="商品" min-width="150" />
        <el-table-column prop="totalAmount" label="金额" width="90" />
        <el-table-column prop="statusText" label="状态" width="90" />
        <el-table-column label="物流" min-width="150">
          <template #default="{ row }">{{ row.carrier ? `${row.carrier} ${row.trackingNo || ''}` : '—' }}</template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" min-width="165" />
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <el-button v-if="Number(row.status) === 1 && String(row.productType).toUpperCase() === 'PHYSICAL'" text type="primary" @click="openShip(row)">登记发货</el-button>
            <el-button v-if="Number(row.status) === 4" text type="primary" @click="openShip(row)">修改物流</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination">
        <el-pagination v-model:current-page="current" :page-size="10" :total="total" layout="prev,pager,next" @current-change="load" />
      </div>
    </section>

    <section class="content-card">
      <div class="section-head">
        <h2 style="margin:0">待审核退款<span class="muted" style="margin-left:8px;font-weight:400">共 {{ refundTotal }} 条，按申请时间倒序</span></h2>
        <el-button text type="primary" :loading="refundLoading" @click="loadRefunds()">刷新</el-button>
      </div>
      <el-table v-loading="refundLoading" :data="refunds" empty-text="暂无待审核的退款申请">
        <el-table-column prop="id" label="申请编号" width="95" />
        <el-table-column prop="orderNo" label="订单号" min-width="190" />
        <el-table-column label="申请人" width="130">
          <template #default="{ row }">{{ row.username || (row.userId ? `用户 ${row.userId}` : '—') }}</template>
        </el-table-column>
        <el-table-column prop="refundAmount" label="退款金额" width="100">
          <template #default="{ row }">¥ {{ row.refundAmount }}</template>
        </el-table-column>
        <el-table-column prop="reason" label="退款原因" min-width="140" />
        <el-table-column label="说明" min-width="150">
          <template #default="{ row }">{{ row.description || '—' }}</template>
        </el-table-column>
        <el-table-column label="退货物流" min-width="150">
          <template #default="{ row }">{{ row.returnCarrier ? `${row.returnCarrier} ${row.returnTrackingNo || ''}` : '—' }}</template>
        </el-table-column>
        <el-table-column prop="createTime" label="申请时间" min-width="165" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="success" text @click="openReview(row, true)">通过</el-button>
            <el-button type="danger" text @click="openReview(row, false)">拒绝</el-button>
          </template>
        </el-table-column>
      </el-table>
    </section>

    <el-dialog v-model="shipOpen" :title="shipTitle" width="min(460px,94vw)" align-center :close-on-click-modal="false">
      <p class="muted" style="margin-top:0">订单号：{{ shipRow?.orderNo }}</p>
      <el-form label-position="top">
        <el-form-item label="物流公司">
          <el-select v-model="shipForm.carrier" filterable allow-create default-first-option placeholder="选择或输入物流公司" style="width:100%">
            <el-option v-for="item in carrierOptions" :key="item" :label="item" :value="item" />
          </el-select>
        </el-form-item>
        <el-form-item label="物流单号">
          <el-input v-model="shipForm.trackingNo" maxlength="100" placeholder="例如：SF1234567890" />
        </el-form-item>
      </el-form>
      <el-alert v-if="isDigital" type="info" :closable="false" show-icon title="该订单为数字专辑，通常无需物流" />
      <template #footer>
        <el-button @click="shipOpen = false">取消</el-button>
        <el-button type="primary" :loading="shipSubmitting" @click="submitShip">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="reviewOpen" :title="reviewTitle" width="min(460px,94vw)" align-center :close-on-click-modal="false">
      <p class="muted" style="margin-top:0">订单号：{{ reviewRow?.orderNo }} · 退款金额 ¥{{ reviewRow?.refundAmount }}</p>
      <p style="margin:0 0 12px">退款原因：{{ reviewRow?.reason }}</p>
      <p v-if="reviewRow?.description" class="muted" style="margin:0 0 12px">说明：{{ reviewRow.description }}</p>
      <p v-if="reviewRow?.returnCarrier" class="muted" style="margin:0 0 12px">退货物流：{{ reviewRow.returnCarrier }} {{ reviewRow.returnTrackingNo }}</p>
      <el-alert v-if="reviewApproved" type="warning" :closable="false" show-icon style="margin-bottom:14px"
        title="通过后订单将置为已退款，并按订单数量回补库存" />
      <el-form label-position="top">
        <el-form-item :label="reviewApproved ? '审核备注（选填）' : '拒绝原因'" :required="!reviewApproved">
          <el-input v-model="reviewRemark" type="textarea" :rows="3" maxlength="200" show-word-limit
            :placeholder="reviewApproved ? '可填写退款说明' : '请说明拒绝原因，用户可见'" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="reviewOpen = false">取消</el-button>
        <el-button :type="reviewApproved ? 'primary' : 'danger'" :loading="reviewSubmitting" @click="submitReview">
          {{ reviewApproved ? '确认通过' : '确认拒绝' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>
