<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { albumDetail, countPlay } from '../../api/album'
import { addCart } from '../../api/cart'
import { useUserStore } from '../../stores/user'
const route=useRoute(),router=useRouter(),user=useUserStore(),album=ref(null),loading=ref(false),quantity=ref(1)
async function load(){loading.value=true;try{album.value=await albumDetail(route.params.id);quantity.value=1}finally{loading.value=false}}
async function cartAdd(){if(!user.isLoggedIn)return router.push({path:'/login',query:{redirect:route.fullPath}});await addCart({albumId:album.value.id,quantity:quantity.value});ElMessage.success('已加入购物车')}
async function played(song){if(!user.isLoggedIn)return;await countPlay(song.id)}
onMounted(load);watch(()=>route.params.id,load)
</script>
<template><div v-loading="loading" v-if="album"><div class="detail-grid"><img class="detail-cover" :src="album.coverUrl||''" :alt="album.title"/><section class="detail-copy"><span class="eyebrow">{{album.productType==='DIGITAL'?'DIGITAL EDITION':'VINYL & MERCH'}}</span><h1>{{album.title}}</h1><p>{{album.artist}} · {{album.releaseDate||'发行日期未提供'}}</p><p class="price-large">¥ {{album.price}}</p><el-tag>{{album.productType==='DIGITAL'?'数字版':'实体版'}}</el-tag><p>{{album.description||'暂无专辑介绍'}}</p><p>库存 {{album.stock??'—'}} · 已售 {{album.sales??'—'}}</p><div class="detail-actions"><el-input-number v-model="quantity" :min="1" :max="Math.max(1,Number(album.stock||1))"/><el-button type="primary" @click="cartAdd">加入购物车</el-button><el-button @click="router.push('/cart')">查看购物车</el-button></div></section></div><section class="content-card" style="margin-top:40px"><div class="section-head"><h2>曲目列表</h2><span class="muted">{{album.songs?.length||0}} 首</span></div><el-empty v-if="!album.songs?.length" description="暂无曲目"/><div v-for="song in album.songs||[]" :key="song.id" class="track-row"><div><b>{{song.trackNumber}}. {{song.title}}</b><div class="muted">{{song.artist}} · {{song.duration}} 秒</div></div><audio v-if="song.previewUrl" :src="song.previewUrl" controls preload="none" @play="played(song)"/></div></section></div><el-skeleton v-else-if="loading" :rows="8" animated/></template>
