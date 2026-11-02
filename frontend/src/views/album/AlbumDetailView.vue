<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { albumDetail } from '../../api/album'
import { addCart } from '../../api/cart'
import { useUserStore } from '../../stores/user'
import { usePlayerStore } from '../../stores/player'

const route = useRoute()
const router = useRouter()
const user = useUserStore()
const player = usePlayerStore()
const album = ref(null)
const loading = ref(false)
const quantity = ref(1)

async function load() {
  loading.value = true
  try {
    album.value = await albumDetail(route.params.id)
    quantity.value = 1
  } finally {
    loading.value = false
  }
}

async function cartAdd() {
  if (!user.isLoggedIn) return router.push({ path: '/login', query: { redirect: route.fullPath } })
  await addCart({ albumId: album.value.id, quantity: quantity.value })
  ElMessage.success('已加入购物车')
}

function playSong(song) {
  return player.playSong(song, album.value?.songs || [], album.value)
}

onMounted(load)
watch(() => route.params.id, load)
</script>

<template>
  <div v-loading="loading" v-if="album">
    <div class="detail-grid">
      <img class="detail-cover" :src="album.coverUrl || ''" :alt="album.title" />
      <section class="detail-copy">
        <span class="eyebrow">{{ album.productType === 'DIGITAL' ? 'DIGITAL EDITION' : 'VINYL & MERCH' }}</span>
        <h1>{{ album.title }}</h1>
        <p>{{ album.artist }} · {{ album.releaseDate || '发行日期未提供' }}</p>
        <p class="price-large">¥ {{ album.price }}</p>
        <el-tag>{{ album.productType === 'DIGITAL' ? '数字版' : '实体版' }}</el-tag>
        <p>{{ album.description || '暂无专辑介绍' }}</p>
        <p>库存 {{ album.stock ?? '—' }} · 已售 {{ album.sales ?? '—' }}</p>
        <div class="detail-actions">
          <el-input-number v-model="quantity" :min="1" :max="Math.max(1, Number(album.stock || 1))" />
          <el-button type="primary" @click="cartAdd">加入购物车</el-button>
          <el-button @click="router.push('/cart')">查看购物车</el-button>
        </div>
      </section>
    </div>

    <section class="content-card track-list" style="margin-top: 40px">
      <div class="section-head">
        <h2>曲目列表</h2>
        <span class="muted">{{ album.songs?.length || 0 }} 首</span>
      </div>
      <el-empty v-if="!album.songs?.length" description="暂无曲目" />
      <div v-for="song in album.songs || []" :key="song.id" class="track-row" :data-song-id="song.id">
        <div class="track-info">
          <b>{{ song.trackNumber }}. {{ song.title }}</b>
          <div class="muted">{{ song.artist }} · {{ song.duration }} 秒</div>
          <small v-if="!song.previewUrl" class="track-unavailable">暂无试听音频</small>
          <small v-else-if="String(song.previewUrl).includes('example.com')" class="track-unavailable">试听地址为示例链接</small>
        </div>
        <el-button
          type="primary"
          plain
          class="track-play"
          :data-testid="`play-song-${song.id}`"
          :aria-label="`播放试听：${song.title}`"
          @click="playSong(song)"
        >播放试听</el-button>
      </div>
    </section>
  </div>
  <el-skeleton v-else-if="loading" :rows="8" animated />
</template>

<style scoped>
.track-info{min-width:0;display:grid;gap:4px}.track-unavailable{color:#e4a16e;font-size:11px}.track-play{flex:none}
@media(max-width:520px){.track-row{align-items:flex-start}.track-play{font-size:12px;padding:8px 10px}}
</style>
