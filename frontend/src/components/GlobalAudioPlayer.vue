<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { usePlayerStore } from '../stores/player'
import { useUserStore } from '../stores/user'
import { countPlay } from '../api/album'

const player = usePlayerStore()
const user = useUserStore()
const audio = ref(null)
const lastCountedSongId = ref(null)
const source = computed(() => player.hasSource ? player.currentSong?.previewUrl : undefined)
const progress = computed(() => player.duration > 0 ? player.currentTime : 0)

onMounted(() => player.attachAudio(audio.value))
onBeforeUnmount(() => player.attachAudio(null))
watch(audio, element => player.attachAudio(element))
watch(source, (url, previousUrl) => {
  if (url !== previousUrl && audio.value) {
    audio.value.load()
    lastCountedSongId.value = null
  }
})

function handlePlaying() {
  player.onPlaying()
  const songId = player.currentSong?.id
  if (user.isLoggedIn && songId && Number(songId) !== Number(lastCountedSongId.value)) {
    lastCountedSongId.value = songId
    countPlay(songId).catch(() => {})
  }
}
function formatTime(seconds) {
  if (!Number.isFinite(seconds) || seconds < 0) return '0:00'
  const value = Math.floor(seconds)
  return `${Math.floor(value / 60)}:${String(value % 60).padStart(2, '0')}`
}
</script>

<template>
  <aside v-if="player.currentSong" class="global-audio-player" data-testid="global-audio-player" :data-player-status="player.status" aria-label="音乐播放器">
    <img class="player-cover" :src="player.currentSong.albumCover || ''" :alt="`${player.currentSong.albumTitle || '歌曲'}封面`" />
    <div class="player-track">
      <strong>{{ player.currentSong.title }}</strong>
      <span>{{ player.currentSong.artist || '未知艺人' }}<template v-if="player.currentSong.albumTitle"> · {{ player.currentSong.albumTitle }}</template></span>
      <span class="player-status" role="status">{{ player.errorMessage || player.statusText }}</span>
    </div>
    <div class="player-controls">
      <el-button text aria-label="上一首" :disabled="player.currentIndex <= 0" @click="player.previous">上一首</el-button>
      <el-button
        type="primary"
        :aria-label="player.isPlaying ? '暂停' : player.status === 'paused' || player.status === 'blocked' ? '继续播放' : '播放'"
        :disabled="!player.hasSource"
        @click="player.togglePlayback"
      >{{ player.isPlaying ? '暂停' : player.status === 'paused' || player.status === 'blocked' ? '继续' : '播放' }}</el-button>
      <el-button text aria-label="下一首" :disabled="player.currentIndex < 0 || player.currentIndex >= player.queue.length - 1" @click="player.next">下一首</el-button>
    </div>
    <div class="player-progress">
      <span>{{ formatTime(player.currentTime) }}</span>
      <input aria-label="播放进度" type="range" min="0" :max="player.duration || 0" step="0.1" :value="progress" :disabled="!player.hasSource || !player.duration" @input="player.seek($event.target.value)" />
      <span>{{ formatTime(player.duration) }}</span>
    </div>
    <label class="player-volume"><span>音量</span><input aria-label="音量" type="range" min="0" max="1" step="0.01" :value="player.volume" @input="player.setVolume($event.target.value)" /></label>
    <audio
      ref="audio"
      :src="source"
      preload="metadata"
      @play="player.onPlay"
      @playing="handlePlaying"
      @pause="player.onPause"
      @timeupdate="player.onTimeUpdate"
      @loadedmetadata="player.onMetadata"
      @ended="player.onEnded"
      @error="player.onError"
    />
  </aside>
</template>

<style scoped>
.global-audio-player{position:fixed;z-index:50;left:50%;bottom:14px;transform:translateX(-50%);width:min(1120px,calc(100% - 28px));display:grid;grid-template-columns:56px minmax(120px,1fr) auto minmax(150px,1.2fr) 110px;align-items:center;gap:14px;padding:12px 16px;border:1px solid #ffffff24;border-radius:16px;background:#171513f5;box-shadow:0 12px 40px #0008;backdrop-filter:blur(14px)}
.player-cover{width:56px;height:56px;object-fit:cover;border-radius:9px;background:#28231e}.player-track{display:grid;gap:3px;min-width:0}.player-track strong,.player-track span{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.player-track strong{font-size:13px}.player-track span{font-size:11px;color:var(--muted)}.player-track .player-status{color:var(--accent)}.player-controls{display:flex;align-items:center;gap:2px}.player-controls :deep(.el-button){margin:0;padding:8px}.player-progress{display:flex;align-items:center;gap:8px;font-size:10px;color:var(--muted)}.player-progress input,.player-volume input{width:100%;accent-color:var(--accent)}.player-volume{display:flex;align-items:center;gap:7px;color:var(--muted);font-size:10px}.global-audio-player audio{display:none}
@media(max-width:760px){.global-audio-player{grid-template-columns:44px minmax(90px,1fr) auto;gap:8px;padding:9px}.player-cover{width:44px;height:44px}.player-progress{grid-column:1/4}.player-volume{display:none}.player-controls :deep(.el-button){font-size:11px;padding:7px 5px}}
</style>
