<script setup>
import { computed, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { addresses } from '../api/user'
import { createFromCart, createOrder } from '../api/order'
import { albumDetail } from '../api/album'

const props = defineProps({ modelValue: Boolean, items: { type: Array, default: () => [] } })
const emit = defineEmits(['update:modelValue', 'created'])

const router = useRouter()
const visible = computed({ get: () => props.modelValue, set: value => emit('update:modelValue', value) })
const loading = ref(false)
const submitting = ref(false)
const addressList = ref([])
const addressId = ref(null)
const remark = ref('')
const needAddress = ref(false)

const count = computed(() => props.items.reduce((sum, item) => sum + Number(item.quantity || 1), 0))
const amount = computed(() => props.items.reduce((sum, item) => sum + Number(item.price || 0) * Number(item.quantity || 1), 0))

function addressLabel(address) {
  const detail = address.fullAddress || [address.province, address.city, address.district, address.detailAddress].filter(Boolean).join(' ')
  return `${address.receiverName} ${address.receiverPhone} · ${detail}`
}

// 购物车接口未返回商品形态时（旧后端），回查专辑详情兜底
async function detectPhysical(items) {
  const flags = []
  for (const item of items) {
    if (item.productType) { flags.push(String(item.productType).toUpperCase() === 'PHYSICAL'); continue }
    try {
      const album = await albumDetail(item.albumId)
      flags.push(String(album?.productType || 'PHYSICAL').toUpperCase() === 'PHYSICAL')
    } catch { flags.push(true) }
  }
  return flags.some(Boolean)
}

watch(() => props.modelValue, async open => {
  if (!open) return
  remark.value = ''
  addressId.value = null
  addressList.value = []
  needAddress.value = false
  loading.value = true
  try {
    needAddress.value = await detectPhysical(props.items)
    if (needAddress.value) {
      addressList.value = (await addresses()) || []
      const preferred = addressList.value.find(address => Number(address.isDefault) === 1) || addressList.value[0]
      addressId.value = preferred?.id ?? null
    }
  } catch { /* 地址加载失败时保持空列表，由用户去添加 */ } finally {
    loading.value = false
  }
})

function goAddress() {
  visible.value = false
  router.push('/addresses')
}

async function submit() {
  if (submitting.value) return
  if (needAddress.value && !addressId.value) return ElMessage.warning('请先选择收货地址')
  submitting.value = true
  try {
    const common = { remark: remark.value.trim() || undefined, ...(needAddress.value ? { addressId: addressId.value } : {}) }
    const order = props.items.length > 1
      ? await createFromCart(common)
      : await createOrder({ albumId: props.items[0].albumId, quantity: Number(props.items[0].quantity), ...common })
    visible.value = false
    emit('created', order)
  } catch {
    // 请求拦截器已提示失败原因（库存不足、地址失效等），保留弹窗便于修改后重试
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <el-dialog v-model="visible" title="确认订单" width="min(560px,94vw)" align-center :close-on-click-modal="false">
    <div v-loading="loading">
      <div v-for="(item, index) in items" :key="index" class="list-row">
        <img v-if="item.albumCover" :src="item.albumCover" width="56" height="56" style="object-fit:cover;border-radius:8px"/>
        <div style="flex:1;min-width:0">
          <b>{{ item.albumName }}</b>
          <p class="muted" style="margin:4px 0 0">¥{{ item.price }} × {{ item.quantity }}</p>
        </div>
        <strong>¥{{ (Number(item.price || 0) * Number(item.quantity || 1)).toFixed(2) }}</strong>
      </div>

      <div v-if="needAddress" style="margin-top:18px">
        <p class="muted" style="margin:0 0 8px">收货地址</p>
        <template v-if="addressList.length">
          <el-select v-model="addressId" style="width:100%" placeholder="请选择收货地址">
            <el-option v-for="address in addressList" :key="address.id" :label="addressLabel(address)" :value="address.id"/>
          </el-select>
          <el-button text style="margin-top:6px;padding-left:0" @click="goAddress">管理收货地址</el-button>
        </template>
        <div v-else class="content-card" style="margin:0">
          <p style="margin:0 0 12px">该订单包含实体专辑，需要先添加收货地址才能下单。</p>
          <el-button type="primary" @click="goAddress">去添加收货地址</el-button>
        </div>
      </div>
      <p v-else class="muted" style="margin:18px 0 0">数字专辑：支付成功后可直接在订单详情获取内容，无需收货地址。</p>

      <div style="margin-top:16px">
        <p class="muted" style="margin:0 0 8px">订单备注（选填）</p>
        <el-input v-model="remark" maxlength="200" placeholder="例如：工作日送达"/>
      </div>

      <div class="section-head" style="margin:20px 0 0">
        <span class="muted">共 {{ count }} 件</span>
        <strong class="price-large">¥ {{ amount.toFixed(2) }}</strong>
      </div>
    </div>
    <template #footer>
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" :loading="submitting" :disabled="needAddress && !addressId" @click="submit">创建订单并支付</el-button>
    </template>
  </el-dialog>
</template>
