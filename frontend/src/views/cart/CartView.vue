<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { cart, changeQuantity, clearCart, removeCart, selectAllCart, selectCart } from '../../api/cart'
import { addresses } from '../../api/user'
import { createOrder } from '../../api/order'
import { albumDetail } from '../../api/album'
import PageTitle from '../../components/PageTitle.vue'
const data=ref(null),loading=ref(false)
async function load(){loading.value=true;try{data.value=await cart()}finally{loading.value=false}}
async function checkout(item){const product=await albumDetail(item.albumId);const physical=String(product.productType||'PHYSICAL').toUpperCase()==='PHYSICAL';let addressId;if(physical){const list=await addresses();if(!list.length)return ElMessage.warning('请先添加收货地址');const def=list.find(a=>Number(a.isDefault)===1)||list[0];addressId=def.id}await ElMessageBox.confirm(`创建“${item.albumName}”订单？${physical?' 将使用默认收货地址。':''}`,'确认下单');const order=await createOrder({albumId:item.albumId,quantity:Number(item.quantity),...(addressId?{addressId}:{})});ElMessage.success(`订单已创建：${order.orderNo}`);location.href='/orders'}
async function update(fn,...args){await fn(...args);await load()}
onMounted(load)
</script>
<template><PageTitle eyebrow="YOUR BAG" title="购物袋" description="确认收藏清单，并逐件创建订单。"/><div v-loading="loading" class="content-card"><template v-if="data?.items?.length"><div class="section-head"><h2>{{data.selectedCount||0}} 件已选</h2><strong class="price-large">¥ {{data.selectedAmount||'0.00'}}</strong></div><el-button text @click="update(selectAllCart, data.items.every(x=>Number(x.isSelected)===1)?0:1)">{{data.items.every(x=>Number(x.isSelected)===1)?'取消全选':'全选'}}</el-button><div v-for="item in data.items" :key="item.id" class="list-row"><el-checkbox :model-value="Number(item.isSelected)===1" @change="v=>update(selectCart,item.id,v?1:0)"/><img v-if="item.albumCover" :src="item.albumCover" width="72" height="72" style="object-fit:cover;border-radius:8px"/><div style="flex:1"><RouterLink :to="`/albums/${item.albumId}`"><b>{{item.albumName}}</b></RouterLink><p class="muted">¥{{item.price}} · 小计 ¥{{item.subtotal}}</p></div><el-input-number :model-value="item.quantity" :min="1" @change="v=>update(changeQuantity,item.id,v)"/><el-button type="primary" @click="checkout(item)">单件结算</el-button><el-button type="danger" plain @click="update(removeCart,item.id)">移除</el-button></div><p class="muted">后端下单接口每次创建一个专辑订单，暂不支持购物车批量合并结算。</p><el-button type="danger" text @click="ElMessageBox.confirm('清空购物车？').then(()=>update(clearCart))">清空购物车</el-button></template><el-empty v-else description="购物袋还是空的"/></div></template>
