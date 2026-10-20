<script setup>
import { onMounted, ref } from 'vue'
import { albums } from '../../api/album'
import AlbumCard from '../../components/AlbumCard.vue'
import PageTitle from '../../components/PageTitle.vue'
const rows=ref([]);const loading=ref(false);const keyword=ref('');const page=ref(1);const total=ref(0);const size=12
async function load(){loading.value=true;try{const data=await albums({current:page.value,size,keyword:keyword.value||undefined});rows.value=data?.records||[];total.value=Number(data?.total||0)}finally{loading.value=false}}
function search(){page.value=1;load()}
onMounted(load)
</script>
<template><section class="hero"><div><span class="eyebrow">TIDE RECORDS · CURATED FOR YOU</span><h1>把喜欢的音乐，<br/>收藏成日常。</h1><p>发现数字专辑与实体唱片。每一张封面背后，都有一段值得反复聆听的故事。</p><div class="search-row"><el-input v-model="keyword" placeholder="搜索专辑或艺人" clearable @keyup.enter="search"/><el-button type="primary" @click="search">搜索</el-button></div></div></section><div class="section-head"><div><span class="eyebrow">THE COLLECTION</span><h2>专辑精选</h2></div><span class="muted">{{total}} 张专辑</span></div><div v-loading="loading" class="album-grid"><AlbumCard v-for="item in rows" :key="item.id" :album="item"/></div><el-empty v-if="!loading&&!rows.length" description="暂时没有专辑，试试其他关键词"/><div class="pagination"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="prev, pager, next" @current-change="load"/></div></template>
