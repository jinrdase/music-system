import { computed, nextTick, ref, shallowRef } from 'vue'
import { defineStore } from 'pinia'
import { ElMessage } from 'element-plus'

function isExampleUrl(value) {
  try {
    const hostname = new URL(value, window.location.href).hostname.toLowerCase()
    return hostname === 'example.com' || hostname.endsWith('.example.com')
  } catch {
    return false
  }
}

export const usePlayerStore = defineStore('player', () => {
  const audioElement = shallowRef(null)
  const currentSong = ref(null)
  const queue = ref([])
  const currentIndex = ref(-1)
  const status = ref('idle')
  const currentTime = ref(0)
  const duration = ref(0)
  const volume = ref(0.8)
  const errorMessage = ref('')

  const hasSource = computed(() => Boolean(currentSong.value?.previewUrl) && !isExampleUrl(currentSong.value.previewUrl))
  const isPlaying = computed(() => status.value === 'playing')
  const statusText = computed(() => ({
    idle: '选择一首歌曲开始试听',
    loading: '正在加载试听音频…',
    playing: '正在播放',
    paused: '已暂停',
    unavailable: '没有可播放的试听音频',
    blocked: '浏览器阻止了自动播放，请再次点击播放',
    error: '音频加载失败',
    ended: '播放结束',
  })[status.value] || '播放器状态未知')

  function attachAudio(element) {
    audioElement.value = element
    if (element) element.volume = volume.value
  }

  function setUnavailable(song, message) {
    status.value = 'unavailable'
    errorMessage.value = message
    ElMessage.warning(message)
    return false
  }

  async function playSong(song, songs, album) {
    const tracks = Array.isArray(songs) ? songs : [song]
    queue.value = tracks.map(track => ({ ...track, albumCover: album?.coverUrl || '', albumTitle: album?.title || '' }))
    currentIndex.value = Math.max(0, queue.value.findIndex(track => Number(track.id) === Number(song.id)))
    currentSong.value = queue.value[currentIndex.value] || { ...song }
    currentTime.value = 0
    duration.value = 0
    errorMessage.value = ''

    const url = String(song.previewUrl || '').trim()
    if (!url) return setUnavailable(song, '这首歌曲没有配置试听音频，暂时无法播放。')
    if (isExampleUrl(url)) return setUnavailable(song, '这首歌曲仍使用 example.com 示例地址，没有真实音频文件。')

    status.value = 'loading'
    await nextTick()
    if (!audioElement.value) {
      status.value = 'error'
      errorMessage.value = '播放器尚未就绪，请稍后重试。'
      ElMessage.error(errorMessage.value)
      return false
    }

    try {
      audioElement.value.volume = volume.value
      await audioElement.value.play()
      status.value = 'playing'
      return true
    } catch (error) {
      if (error?.name === 'NotAllowedError') {
        status.value = 'blocked'
        errorMessage.value = '浏览器阻止了自动播放，请再次点击播放。'
      } else {
        status.value = 'error'
        errorMessage.value = '音频加载失败，请检查试听地址和文件。'
      }
      ElMessage.warning(errorMessage.value)
      return false
    }
  }

  async function togglePlayback() {
    if (!hasSource.value || !audioElement.value) {
      ElMessage.warning(errorMessage.value || '这首歌曲没有可播放的试听音频。')
      return false
    }
    if (!audioElement.value.paused) {
      audioElement.value.pause()
      status.value = 'paused'
      return true
    }
    try {
      await audioElement.value.play()
      status.value = 'playing'
      errorMessage.value = ''
      return true
    } catch (error) {
      status.value = error?.name === 'NotAllowedError' ? 'blocked' : 'error'
      errorMessage.value = status.value === 'blocked'
        ? '浏览器阻止了自动播放，请再次点击播放。'
        : '音频加载失败，请检查试听地址和文件。'
      ElMessage.warning(errorMessage.value)
      return false
    }
  }

  async function playIndex(index) {
    if (!queue.value.length) return false
    const boundedIndex = Math.max(0, Math.min(index, queue.value.length - 1))
    return playSong(queue.value[boundedIndex], queue.value, {
      title: queue.value[boundedIndex].albumTitle,
      coverUrl: queue.value[boundedIndex].albumCover,
    })
  }

  function previous() {
    if (currentIndex.value > 0) return playIndex(currentIndex.value - 1)
    ElMessage.info('已经是当前专辑的第一首歌曲。')
    return false
  }

  function next() {
    if (currentIndex.value >= 0 && currentIndex.value < queue.value.length - 1) return playIndex(currentIndex.value + 1)
    ElMessage.info('已经是当前专辑的最后一首歌曲。')
    return false
  }

  function seek(value) {
    const time = Number(value)
    if (!audioElement.value || !Number.isFinite(time) || !Number.isFinite(duration.value)) return
    audioElement.value.currentTime = Math.max(0, Math.min(time, duration.value))
    currentTime.value = audioElement.value.currentTime
  }

  function setVolume(value) {
    volume.value = Math.max(0, Math.min(1, Number(value)))
    if (audioElement.value) audioElement.value.volume = volume.value
  }

  function onPlay() { status.value = 'loading' }
  function onPlaying() { status.value = 'playing' }
  function onPause() {
    if (status.value !== 'ended' && status.value !== 'unavailable' && status.value !== 'error') status.value = 'paused'
  }
  function onTimeUpdate() {
    if (audioElement.value) currentTime.value = audioElement.value.currentTime || 0
  }
  function onMetadata() {
    if (audioElement.value) duration.value = Number.isFinite(audioElement.value.duration) ? audioElement.value.duration : 0
  }
  function onEnded() {
    status.value = 'ended'
    if (currentIndex.value < queue.value.length - 1) next()
  }
  function onError() {
    if (!hasSource.value) return
    status.value = 'error'
    errorMessage.value = '音频加载失败，请检查试听地址和文件是否可访问。'
    ElMessage.error(errorMessage.value)
  }

  return {
    audioElement, currentSong, queue, currentIndex, status, currentTime, duration, volume,
    errorMessage, hasSource, isPlaying, statusText, attachAudio, playSong, togglePlayback,
    previous, next, seek, setVolume, onPlay, onPlaying, onPause, onTimeUpdate, onMetadata, onEnded, onError,
  }
})
