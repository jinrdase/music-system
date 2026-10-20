<script setup>
defineProps({ album: { type: Object, required: true } })
</script>
<template><article class="album-card"><RouterLink :to="`/albums/${album.id}`" class="album-cover"><img v-if="album.coverUrl" :src="album.coverUrl" :alt="album.title" loading="lazy"/><div v-else class="cover-placeholder">◉</div><span class="cover-type">{{album.productType === 'DIGITAL' ? '数字版' : '实体版'}}</span></RouterLink><div class="album-meta"><RouterLink :to="`/albums/${album.id}`" class="album-title">{{album.title}}</RouterLink><span class="album-artist">{{album.artist}}</span><div class="album-bottom"><strong>¥ {{album.price}}</strong><span>余 {{album.stock ?? '—'}}</span></div></div></article></template>
