<script setup>
import { computed, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { createPayment, mockPay, queryPayment } from '../api/order'

const props = defineProps({ modelValue: Boolean, order: Object })
const emit = defineEmits(['update:modelValue', 'paid'])

const visible = computed({ get: () => props.modelValue, set: value => emit('update:modelValue', value) })
const payment = ref(null)
const loading = ref(false)
const checking = ref(false)
const paying = ref(false)
const error = ref('')

const isMock = computed(() => Boolean(payment.value) && !payment.value.payUrl)

async function createPaymentRecord() {
  payment.value = null
  error.value = ''
  if (!props.order?.id) { error.value = '订单信息缺失，无法发起支付'; return }
  loading.value = true
  try {
    payment.value = await createPayment({ orderId: props.order.id })
  } catch (e) {
    error.value = e.message || '创建支付单失败'
  } finally {
    loading.value = false
  }
}

watch(() => props.modelValue, open => { if (open) createPaymentRecord() })

async function confirmMockPay() {
  if (!payment.value?.paymentNo || paying.value) return
  paying.value = true
  try {
    await mockPay(payment.value.paymentNo)
    const result = await queryPayment(payment.value.paymentNo)
    if (Number(result.status) === 1) {
      ElMessage.success(`模拟支付成功，订单 ${result.orderNo} 已支付`)
      visible.value = false
      emit('paid', result)
    } else {
      ElMessage.warning('支付单暂未确认成功，请稍后点击“查询支付状态”')
    }
  } catch (e) {
    // 请求拦截器已提示错误原因，这里保持弹窗不关闭，便于重试
  } finally {
    paying.value = false
  }
}

async function refreshStatus() {
  if (!payment.value?.paymentNo || checking.value) return
  checking.value = true
  try {
    const result = await queryPayment(payment.value.paymentNo)
    if (Number(result.status) === 1) {
      ElMessage.success('支付已确认成功')
      visible.value = false
      emit('paid', result)
    } else if (Number(result.status) === 2) {
      ElMessage.warning('该支付单已关闭或已过期，请重新发起支付')
    } else {
      ElMessage.info('支付单仍为待支付状态')
    }
  } finally {
    checking.value = false
  }
}

function openCashier() {
  if (payment.value?.payUrl) window.open(payment.value.payUrl, '_blank', 'noopener')
}
</script>

<template>
  <el-dialog v-model="visible" title="订单支付" width="min(480px,94vw)" align-center :close-on-click-modal="false">
    <div v-loading="loading" style="min-height:120px">
      <p class="muted" style="margin-top:0">订单号：{{ order?.orderNo }}</p>
      <div class="section-head">
        <span>应付金额</span>
        <strong class="price-large">¥ {{ payment?.amount ?? order?.totalAmount }}</strong>
      </div>
      <el-alert v-if="error" :title="error" type="error" :closable="false" show-icon style="margin-bottom:12px"/>
      <template v-if="payment">
        <p class="muted">支付单号：{{ payment.paymentNo }}</p>
        <el-alert v-if="isMock" type="info" :closable="false" show-icon
                  title="当前为本地模拟支付（演示环境）"
                  description="后端已开启 pay.mock-enabled，点击下方“模拟支付”即把订单推进为已支付，不产生真实资金交易。"/>
        <el-alert v-else type="warning" :closable="false" show-icon
                  title="将跳转到支付宝收银台"
                  description="支付完成后回到本页点击“查询支付状态”确认结果。"/>
        <p class="muted" style="margin-bottom:0">支付单 15 分钟内有效，超时后需重新发起支付。</p>
      </template>
    </div>
    <template #footer>
      <el-button @click="visible = false">稍后支付</el-button>
      <el-button v-if="error" @click="createPaymentRecord">重试</el-button>
      <el-button v-if="payment" :loading="checking" @click="refreshStatus">查询支付状态</el-button>
      <el-button v-if="payment && !isMock" type="primary" @click="openCashier">打开支付宝收银台</el-button>
      <el-button v-if="isMock" type="primary" :loading="paying" @click="confirmMockPay">模拟支付</el-button>
    </template>
  </el-dialog>
</template>
