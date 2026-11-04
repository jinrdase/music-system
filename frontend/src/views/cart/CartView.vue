<script setup>
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { cart, changeQuantity, clearCart, removeCart, selectAllCart, selectCart } from '../../api/cart'
import { addresses } from '../../api/user'
import { createOrder, createFromCart } from '../../api/order'
import { albumDetail } from '../../api/album'
import { confirmAction } from '../../utils/confirm'
import PageTitle from '../../components/PageTitle.vue'
const data=ref(null),loading=ref(false)
// 结算确认弹窗:实体商品必须先选收货地址再下单
const checkoutOpen=ref(false),checkoutItem=ref(null),submitting=ref(false)
const addressList=ref([]),addressLoading=ref(false),addressId=ref(null)
const noAddress=computed(()=>!addressLoading.value&&!addressList.value.length)
// 合并结算：所有勾选商品合并为一张多明细订单（后端 createFromCart）
const batchOpen=ref(false),batchSubmitting=ref(false)
async function loadAddressesForCheckout(){
  addressLoading.value=true
  try{addressList.value=await addresses()||[]}finally{addressLoading.value=false}
  const def=addressList.value.find(a=>Number(a.isDefault)===1)||addressList.value[0]
  addressId.value=def?.id||null
}
async function batchCheckout(){
  if(!data.value?.selectedCount){return ElMessage.warning('请先勾选要结算的商品')}
  batchOpen.value=true
  await loadAddressesForCheckout()
}
async function submitBatch(){
  batchSubmitting.value=true
  try{
    const order=await createFromCart(addressId.value?{addressId:addressId.value}:{})
    batchOpen.value=false
    ElMessage.success(`合并订单已创建：${order.orderNo}（共 ${data.value.selectedCount} 件商品）`)
    location.href='/orders'
  }finally{batchSubmitting.value=false}
}
async function load(){loading.value=true;try{data.value=await cart()}finally{loading.value=false}}
async function checkout(item){
  const product=await albumDetail(item.albumId)
  const physical=String(product.productType||'PHYSICAL').toUpperCase()==='PHYSICAL'
  if(!physical){
    if(!(await confirmAction(`「${item.albumName}」为数字商品，无需收货地址，将直接创建订单并跳转支付。`,{title:'确认结算',confirmText:'去下单'})))return
    return submitOrder(Number(item.quantity),null)
  }
  checkoutItem.value=item;checkoutOpen.value=true
  addressLoading.value=true
  try{addressList.value=await addresses()||[]}finally{addressLoading.value=false}
  const def=addressList.value.find(a=>Number(a.isDefault)===1)||addressList.value[0]
  addressId.value=def?.id||null
}
async function submitOrder(quantity,addressIdValue){
  submitting.value=true
  try{
    const order=await createOrder({albumId:checkoutItem.value.albumId,quantity,...(addressIdValue?{addressId:addressIdValue}:{})})
    checkoutOpen.value=false
    ElMessage.success(`订单已创建：${order.orderNo}`)
    location.href='/orders'
  }finally{submitting.value=false}
}
async function submitCheckout(){
  if(!addressId.value)return ElMessage.warning('请选择收货地址')
  await submitOrder(Number(checkoutItem.value.quantity),addressId.value)
}
async function update(fn,...args){await fn(...args);await load()}
async function clearAll(){if(!(await confirmAction('将移除购物袋内全部商品，确定清空？',{title:'清空购物袋',confirmText:'清空',cancelText:'保留'})))return;await clearCart();ElMessage.success('购物袋已清空');await load()}
onMounted(load)
</script>
<template><PageTitle eyebrow="YOUR BAG" title="购物袋" description="确认收藏清单，并逐件创建订单。"/><div v-loading="loading" class="content-card"><template v-if="data?.items?.length"><div class="section-head"><h2>{{data.selectedCount||0}} 件已选</h2><strong class="price-large">¥ {{data.selectedAmount||'0.00'}}</strong><el-button type="primary" :disabled="!data.selectedCount" @click="batchCheckout">合并结算（{{data.selectedCount||0}} 件）</el-button></div><el-button text @click="update(selectAllCart, data.items.every(x=>Number(x.isSelected)===1)?0:1)">{{data.items.every(x=>Number(x.isSelected)===1)?'取消全选':'全选'}}</el-button><div v-for="item in data.items" :key="item.id" class="list-row"><el-checkbox :model-value="Number(item.isSelected)===1" @change="v=>update(selectCart,item.id,v?1:0)"/><img v-if="item.albumCover" :src="item.albumCover" width="72" height="72" style="object-fit:cover;border-radius:8px"/><div style="flex:1"><RouterLink :to="`/albums/${item.albumId}`"><b>{{item.albumName}}</b></RouterLink><p class="muted">¥{{item.price}} · 小计 ¥{{item.subtotal}}</p></div><el-input-number :model-value="item.quantity" :min="1" @change="v=>update(changeQuantity,item.id,v)"/><el-button type="primary" @click="checkout(item)">单件结算</el-button><el-button type="danger" plain @click="update(removeCart,item.id)">移除</el-button></div><p class="muted">提示：勾选商品后点「合并结算」，所有勾选商品将合并为一张多明细订单；逐件「单件结算」则各生成一张独立订单。</p><el-button type="danger" text @click="clearAll">清空购物袋</el-button></template><el-empty v-else description="购物袋还是空的"/></div>
<el-dialog v-model="checkoutOpen" title="确认订单" width="min(560px,92vw)">
  <div v-if="checkoutItem" class="checkout-item">
    <img v-if="checkoutItem.albumCover" :src="checkoutItem.albumCover" class="checkout-cover" alt=""/>
    <div class="checkout-info">
      <b>{{checkoutItem.albumName}}</b>
      <p class="muted">¥{{checkoutItem.price}} × {{checkoutItem.quantity}} = ¥{{checkoutItem.subtotal}}</p>
    </div>
  </div>
  <el-divider content-position="left">收货地址</el-divider>
  <div v-loading="addressLoading">
    <template v-if="addressList.length">
      <el-select v-model="addressId" placeholder="选择收货地址" style="width:100%">
        <el-option v-for="a in addressList" :key="a.id" :value="a.id"
          :label="`${a.receiverName} · ${a.receiverPhone}`"
          :description="a.fullAddress||`${a.province}${a.city}${a.district}${a.detailAddress}`">
          <div class="address-option">
            <span class="address-option-name">{{a.receiverName}}<el-tag v-if="Number(a.isDefault)===1" type="success" size="small" style="margin-left:8px">默认</el-tag></span>
            <span class="muted address-option-detail">{{a.fullAddress||`${a.province}${a.city}${a.district}${a.detailAddress}`}}</span>
          </div>
        </el-option>
      </el-select>
      <RouterLink to="/addresses" class="muted address-manage-link">管理收货地址</RouterLink>
    </template>
    <el-empty v-else-if="noAddress" description="还没有收货地址，实体商品需要先添加一个">
      <RouterLink to="/addresses"><el-button type="primary">去添加地址</el-button></RouterLink>
    </el-empty>
  </div>
  <template #footer>
    <el-button @click="checkoutOpen=false">取消</el-button>
    <el-button type="primary" :loading="submitting" :disabled="noAddress||!addressId" @click="submitCheckout">提交订单</el-button>
  </template>
</el-dialog>
<el-dialog v-model="batchOpen" title="合并结算勾选商品" width="min(560px,92vw)">
  <p style="margin-top:0">将把 <b>{{data?.selectedCount||0}}</b> 件勾选商品合并为 <b>一张订单</b>，合计 <b class="price-large">¥ {{data?.selectedAmount||'0.00'}}</b>。</p>
  <el-alert title="勾选商品中包含实体专辑时必须选择收货地址；全部为数字专辑可不选。" type="info" :closable="false" show-icon style="margin-bottom:14px"/>
  <el-divider content-position="left">收货地址</el-divider>
  <div v-loading="addressLoading">
    <template v-if="addressList.length">
      <el-select v-model="addressId" placeholder="选择收货地址（全数字商品可不选）" clearable style="width:100%">
        <el-option v-for="a in addressList" :key="a.id" :value="a.id"
          :label="`${a.receiverName} · ${a.receiverPhone}`"
          :description="a.fullAddress||`${a.province}${a.city}${a.district}${a.detailAddress}`">
          <div class="address-option">
            <span class="address-option-name">{{a.receiverName}}<el-tag v-if="Number(a.isDefault)===1" type="success" size="small" style="margin-left:8px">默认</el-tag></span>
            <span class="muted address-option-detail">{{a.fullAddress||`${a.province}${a.city}${a.district}${a.detailAddress}`}}</span>
          </div>
        </el-option>
      </el-select>
      <RouterLink to="/addresses" class="muted address-manage-link">管理收货地址</RouterLink>
    </template>
    <el-empty v-else-if="noAddress" description="还没有收货地址，勾选商品含实体专辑时需要先添加一个">
      <RouterLink to="/addresses"><el-button type="primary">去添加地址</el-button></RouterLink>
    </el-empty>
  </div>
  <template #footer>
    <el-button @click="batchOpen=false">取消</el-button>
    <el-button type="primary" :loading="batchSubmitting" :disabled="batchSubmitting" @click="submitBatch">提交合并订单</el-button>
  </template>
</el-dialog>
</template>
<style scoped>
.checkout-item{display:flex;gap:14px;align-items:center}
.checkout-cover{width:64px;height:64px;object-fit:cover;border-radius:8px}
.checkout-info p{margin:6px 0 0}
.address-option{display:grid;gap:2px;line-height:1.4}
.address-option-name{font-weight:600}
.address-option-detail{font-size:12px}
.address-manage-link{display:inline-block;margin-top:10px;font-size:13px}
.address-manage-link:hover{color:var(--accent-text)}
</style>
