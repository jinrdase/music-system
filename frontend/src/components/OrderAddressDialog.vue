<script setup>
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { updateOrderAddress } from '../api/order'
import { addresses } from '../api/user'

// 待支付订单修改收货地址：订单列表与订单详情共用
const props = defineProps({
  orderNo: { type: String, default: '' },
  modelValue: Boolean,
})
const emit = defineEmits(['update:modelValue', 'saved'])

const open = ref(props.modelValue)
const list = ref([])
const loading = ref(false)
const busy = ref(false)
const addressId = ref(null)

watch(() => props.modelValue, async visible => {
  open.value = visible
  if (!visible) return
  loading.value = true
  try {
    list.value = await addresses() || []
  } finally {
    loading.value = false
  }
  const def = list.value.find(a => Number(a.isDefault) === 1) || list.value[0]
  addressId.value = def?.id || null
})
watch(open, value => { if (!value) emit('update:modelValue', false) })

async function submit() {
  if (!addressId.value) return ElMessage.warning('请选择收货地址')
  busy.value = true
  try {
    await updateOrderAddress(props.orderNo, { addressId: addressId.value })
    ElMessage.success('收货地址已更新')
    open.value = false
    emit('saved')
  } finally {
    busy.value = false
  }
}
</script>
<template>
  <el-dialog v-model="open" :title="`修改收货地址${orderNo ? ` · ${orderNo}` : ''}`" width="min(560px,92vw)">
    <div v-loading="loading">
      <template v-if="list.length">
        <el-select v-model="addressId" placeholder="选择收货地址" style="width:100%">
          <el-option v-for="a in list" :key="a.id" :value="a.id" :label="`${a.receiverName} · ${a.receiverPhone}`">
            <div class="addr-option">
              <span class="addr-name">{{a.receiverName}}<el-tag v-if="Number(a.isDefault)===1" type="success" size="small" style="margin-left:8px">默认</el-tag></span>
              <span class="addr-detail">{{a.fullAddress||`${a.province}${a.city}${a.district}${a.detailAddress}`}}</span>
            </div>
          </el-option>
        </el-select>
        <RouterLink to="/addresses" class="addr-manage">管理收货地址</RouterLink>
      </template>
      <el-empty v-else-if="!loading" description="还没有收货地址，先去添加一个">
        <RouterLink to="/addresses"><el-button type="primary">去添加地址</el-button></RouterLink>
      </el-empty>
    </div>
    <template #footer>
      <el-button @click="open=false">取消</el-button>
      <el-button type="primary" :loading="busy" :disabled="!list.length||!addressId" @click="submit">保存新地址</el-button>
    </template>
  </el-dialog>
</template>
<style scoped>
.addr-option{display:grid;gap:2px;line-height:1.4}
.addr-name{font-weight:600}
.addr-detail{font-size:12px;color:var(--muted)}
.addr-manage{display:inline-block;margin-top:10px;font-size:13px;color:var(--muted)}
.addr-manage:hover{color:var(--accent-text)}
</style>
