<script setup>
import zhCn from 'element-plus/es/locale/lang/zh-cn'
import GlobalAudioPlayer from './components/GlobalAudioPlayer.vue'
</script>

<template>
  <el-config-provider :locale="zhCn">
    <RouterView />
    <GlobalAudioPlayer />
  </el-config-provider>
</template>
