<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { cart, changeQuantity, clearCart, removeCart, selectAllCart, selectCart } from '../../api/cart'
import PageTitle from '../../components/PageTitle.vue'
import CheckoutDialog from '../../components/CheckoutDialog.vue'
import PaymentDialog from '../../components/PaymentDialog.vue'

const router = useRouter()
const data = ref(null)
const loading = ref(false)
const checkoutOpen = ref(false)
const checkoutItems = ref([])
const payOpen = ref(false)
const payOrder = ref(null)

const items = computed(() => data.value?.items || [])
const selectedItems = computed(() => items.value.filter(item => Number(item.isSelected) === 1 && Number(item.isValid) !== 0))
const allSelected = computed(() => items.value.length > 0 && items.value.every(item => Number(item.isSelected) === 1))
const selectedAmount = computed(() =>
  selectedItems.value.reduce((sum, item) => sum + Number(item.price || 0) * Number(item.quantity || 0), 0))

async function load() {
  loading.value = true
  try { data.value = await cart() } finally { loading.value = false }
}

async function toggleAll() { await selectAllCart(allSelected.value ? 0 : 1); await load() }
async function toggleOne(item, checked) { await selectCart(item.id, checked ? 1 : 0); await load() }
async function changeQuantityOf(item, value) { if (!value || Number(value) === Number(item.quantity)) return; await changeQuantity(item.id, value); await load() }

async function removeItem(item) {
  try { await ElMessageBox.confirm(`从购物袋移除「${item.albumName}」？`, '移除商品') } catch { return }
  await removeCart(item.id)
  await load()
}

async function clearAll() {
  try { await ElMessageBox.confirm('确定清空购物袋？', '清空购物袋') } catch { return }
  await clearCart()
  await load()
}

function openCheckout(list) {
  if (!list.length) return ElMessage.warning('请先勾选要结算的商品')
  if (list.some(item => Number(item.isValid) === 0)) return ElMessage.warning('勾选中包含已失效商品，请先移除后再结算')
  checkoutItems.value = list
  checkoutOpen.value = true
}

async function onOrderCreated(order) {
  // 单件结算后该商品已转成订单，从购物袋移除
  if (checkoutItems.value.length === 1) {
    try { await removeCart(checkoutItems.value[0].id) } catch { /* 清理失败不影响支付 */ }
  }
  payOrder.value = order
  payOpen.value = true
  await load()
}

function onPaid(result) {
  const no = result?.orderNo || payOrder.value?.orderNo
  ElMessage.success('支付成功')
  if (no) router.push(`/orders/${encodeURIComponent(no)}`)
}

onMounted(load)
</script>

<template>
  <PageTitle eyebrow="YOUR BAG" title="购物袋" description="勾选想要的专辑，一次结算并完成模拟支付。"/>
  <div v-loading="loading" class="content-card">
    <template v-if="items.length">
      <div class="section-head">
        <div>
          <h2>{{ selectedItems.length }} 件已选</h2>
          <p class="muted" style="margin:6px 0 0">合计 <strong class="price-large">¥ {{ selectedAmount.toFixed(2) }}</strong></p>
        </div>
        <div class="actions">
          <el-button text @click="toggleAll">{{ allSelected ? '取消全选' : '全选' }}</el-button>
          <el-button type="primary" @click="openCheckout(selectedItems)">结算所选</el-button>
        </div>
      </div>
      <div v-for="item in items" :key="item.id" class="list-row">
        <el-checkbox :model-value="Number(item.isSelected) === 1" :disabled="Number(item.isValid) === 0"
                     @change="checked => toggleOne(item, checked)"/>
        <img v-if="item.albumCover" :src="item.albumCover" width="72" height="72" style="object-fit:cover;border-radius:8px"/>
        <div style="flex:1;min-width:0">
          <RouterLink :to="`/albums/${item.albumId}`"><b>{{ item.albumName }}</b></RouterLink>
          <p class="muted" style="margin:6px 0 0">
            ¥{{ item.price }} · 小计 ¥{{ item.subtotal }}
            <el-tag v-if="Number(item.isValid) === 0" type="danger" size="small" style="margin-left:8px">已失效</el-tag>
          </p>
        </div>
        <el-input-number :model-value="Number(item.quantity)" :min="1" :max="Math.max(1, Number(item.stock || 1))"
                         @change="value => changeQuantityOf(item, value)"/>
        <el-button type="primary" plain :disabled="Number(item.isValid) === 0" @click="openCheckout([item])">单件结算</el-button>
        <el-button type="danger" text @click="removeItem(item)">移除</el-button>
      </div>
      <p class="muted">勾选多件可合并为一张订单；含实体专辑时可选择收货地址，地址在「收货地址」中维护。</p>
      <el-button type="danger" text @click="clearAll">清空购物袋</el-button>
    </template>
    <el-empty v-else description="购物袋还是空的"/>
  </div>
  <CheckoutDialog v-model="checkoutOpen" :items="checkoutItems" @created="onOrderCreated"/>
  <PaymentDialog v-model="payOpen" :order="payOrder" @paid="onPaid"/>
</template>
