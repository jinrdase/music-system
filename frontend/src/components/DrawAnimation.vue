<script setup>
import { computed, onBeforeUnmount, ref, watch } from 'vue'

const props = defineProps({
  modelValue: Boolean,
  records: { type: Array, default: () => [] },
  boxName: { type: String, default: '' }
})
const emit = defineEmits(['update:modelValue', 'finished'])

const phase = ref('rolling')
let timer = null

const visible = computed(() => props.modelValue)
const isSingle = computed(() => props.records.length === 1)
const hasSSR = computed(() => props.records.some(item => Number(item.prizeLevel) === 1))

const LEVEL_TEXT = { 1: 'SSR', 2: 'SR', 3: 'R', 4: 'N' }
const levelText = level => LEVEL_TEXT[Number(level)] || 'N'

// 滚动用的封面：优先用本次奖品图，不足时重复铺满
const reelImages = computed(() => {
  const images = props.records.map(item => item.imageUrl).filter(Boolean)
  if (!images.length) return []
  const list = []
  while (list.length < 9) list.push(...images)
  return list.slice(0, 9)
})

const confetti = Array.from({ length: 18 }, (_, index) => ({
  left: `${(index * 37) % 100}%`,
  delay: `${(index % 6) * 0.12}s`,
  duration: `${1.2 + (index % 5) * 0.25}s`,
  size: `${6 + (index % 4) * 3}px`
}))

function start() {
  clearTimeout(timer)
  phase.value = 'rolling'
  timer = setTimeout(() => { phase.value = 'reveal' }, 1900)
}

function replay() {
  start()
}

function close() {
  clearTimeout(timer)
  emit('update:modelValue', false)
  emit('finished', props.records)
}

watch(() => props.modelValue, open => { if (open) start(); else clearTimeout(timer) })
onBeforeUnmount(() => clearTimeout(timer))
</script>

<template>
  <Teleport to="body">
    <Transition name="draw-fade">
      <div v-if="visible" class="draw-overlay" role="dialog" aria-modal="true">
        <div class="draw-vignette"></div>
        <div class="draw-stage">
          <p class="draw-eyebrow">MYSTERY UNBOXING</p>
          <h2 class="draw-title">
            <template v-if="phase === 'rolling'">正在开启{{ boxName ? `「${boxName}」` : '盲盒' }}…</template>
            <template v-else>{{ isSingle ? '恭喜获得' : `十连结果 · ${records.length} 件奖品` }}</template>
          </h2>

          <div v-if="phase === 'rolling'" class="draw-reel" aria-hidden="true">
            <div class="reel-track" :class="{ still: !reelImages.length }">
              <template v-if="reelImages.length">
                <div v-for="(img, index) in reelImages.concat(reelImages)" :key="index" class="reel-cell">
                  <img :src="img" alt="" />
                </div>
              </template>
              <div v-else v-for="index in 6" :key="`empty-${index}`" class="reel-cell empty">?</div>
            </div>
            <div class="reel-mask left"></div>
            <div class="reel-mask right"></div>
            <div class="reel-pointer"></div>
          </div>
          <p v-if="phase === 'rolling'" class="draw-hint">命运的齿轮正在转动…</p>

          <div v-else class="draw-cards" :class="{ single: isSingle, many: !isSingle }">
            <article
              v-for="(record, index) in records"
              :key="index"
              class="draw-card"
              :class="[`lv-${Number(record.prizeLevel) || 4}`, { legend: Number(record.prizeLevel) === 1 }]"
              :style="{ '--d': `${index * 130}ms` }"
            >
              <div class="card-face card-back"><span>?</span></div>
              <div class="card-face card-front">
                <div class="card-media">
                  <img v-if="record.imageUrl" :src="record.imageUrl" :alt="record.prizeName" />
                  <div v-else class="card-noimg">◉</div>
                </div>
                <div class="card-meta">
                  <span class="card-level">{{ record.prizeLevelName || levelText(record.prizeLevel) }}</span>
                  <strong>{{ record.prizeName }}</strong>
                  <small v-if="Number(record.isGuarantee) === 1">保底获得</small>
                </div>
              </div>
            </article>
          </div>

          <div v-if="phase === 'reveal' && hasSSR" class="draw-confetti" aria-hidden="true">
            <span v-for="(item, index) in confetti" :key="index"
              :style="{ left: item.left, animationDelay: item.delay, animationDuration: item.duration, width: item.size, height: item.size }" />
          </div>

          <div v-if="phase === 'reveal'" class="draw-actions">
            <button type="button" class="draw-btn ghost" @click="replay">再看一次</button>
            <button type="button" class="draw-btn primary" @click="close">收下奖品</button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.draw-overlay {
  position: fixed;
  inset: 0;
  z-index: 3000;
  display: flex;
  padding: 24px;
  background: radial-gradient(circle at 50% 30%, rgba(255, 176, 96, 0.16), transparent 55%), rgba(9, 8, 7, 0.92);
  backdrop-filter: blur(6px);
  overflow-y: auto;
}
.draw-vignette {
  position: absolute;
  inset: 0;
  pointer-events: none;
  background: radial-gradient(circle at 50% 45%, rgba(255, 214, 152, 0.12), transparent 60%);
  animation: vignettePulse 2.6s ease-in-out infinite;
}
.draw-stage {
  position: relative;
  width: min(880px, 100%);
  margin: auto;
  text-align: center;
  color: #f6efe6;
}
.draw-eyebrow {
  margin: 0 0 10px;
  font-size: 12px;
  letter-spacing: 0.32em;
  color: rgba(246, 239, 230, 0.55);
}
.draw-title {
  margin: 0 0 26px;
  font-size: clamp(20px, 3vw, 28px);
  font-weight: 600;
  letter-spacing: 0.02em;
}
.draw-hint { margin: 18px 0 0; font-size: 13px; color: rgba(246, 239, 230, 0.5); }

/* 滚动抽奖 */
.draw-reel {
  position: relative;
  overflow: hidden;
  height: 148px;
  border-radius: 18px;
  border: 1px solid rgba(255, 205, 140, 0.25);
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.06), rgba(255, 255, 255, 0.01));
  box-shadow: inset 0 0 40px rgba(0, 0, 0, 0.45);
}
.reel-track {
  display: flex;
  gap: 14px;
  padding: 14px;
  width: max-content;
  animation: reelScroll 1.4s linear infinite;
}
.reel-track.still { animation: none; }
.reel-cell {
  flex: 0 0 auto;
  width: 106px;
  height: 106px;
  border-radius: 12px;
  overflow: hidden;
  background: linear-gradient(145deg, #40332a, #171514);
  display: grid;
  place-items: center;
  font-size: 34px;
  color: rgba(255, 214, 152, 0.5);
}
.reel-cell img { width: 100%; height: 100%; object-fit: cover; }
.reel-mask { position: absolute; top: 0; bottom: 0; width: 64px; pointer-events: none; }
.reel-mask.left { left: 0; background: linear-gradient(90deg, #12100f, transparent); }
.reel-mask.right { right: 0; background: linear-gradient(270deg, #12100f, transparent); }
.reel-pointer {
  position: absolute;
  top: 8px;
  bottom: 8px;
  left: 50%;
  width: 2px;
  margin-left: -1px;
  background: linear-gradient(180deg, transparent, #ffcf8a, transparent);
  box-shadow: 0 0 12px rgba(255, 207, 138, 0.8);
}
@keyframes reelScroll {
  from { transform: translateX(0); }
  to { transform: translateX(-50%); }
}

/* 卡牌 */
.draw-cards { display: flex; flex-wrap: wrap; gap: 16px; justify-content: center; }
.draw-card { position: relative; width: 150px; height: 210px; }
.draw-cards.single .draw-card { width: 240px; height: 336px; }
.card-face {
  position: absolute;
  inset: 0;
  border-radius: 16px;
  overflow: hidden;
}
.card-back {
  display: grid;
  place-items: center;
  font-size: 44px;
  color: rgba(255, 214, 152, 0.55);
  background: linear-gradient(160deg, #2b2119, #14110f);
  border: 1px solid rgba(255, 205, 140, 0.25);
  animation: backOut 0.45s ease var(--d, 0ms) both;
}
.card-front {
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, #241b15, #14110f);
  border: 1px solid rgba(255, 205, 140, 0.3);
  animation: frontIn 0.55s cubic-bezier(0.22, 0.8, 0.3, 1) var(--d, 0ms) both;
}
.card-media { flex: 1; min-height: 0; background: rgba(255, 255, 255, 0.03); }
.card-media img { width: 100%; height: 100%; object-fit: cover; display: block; }
.card-noimg { width: 100%; height: 100%; display: grid; place-items: center; font-size: 40px; color: rgba(255, 214, 152, 0.4); }
.card-meta { padding: 10px 12px 12px; text-align: left; display: grid; gap: 4px; }
.card-meta strong { font-size: 14px; font-weight: 600; line-height: 1.35; }
.card-meta small { font-size: 11px; color: #ffcf8a; }
.card-level {
  justify-self: start;
  font-size: 10px;
  letter-spacing: 0.14em;
  padding: 2px 8px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
  color: rgba(246, 239, 230, 0.8);
}
.draw-card.lv-1 .card-front { border-color: rgba(255, 205, 120, 0.9); box-shadow: 0 0 26px rgba(255, 186, 96, 0.45), inset 0 0 22px rgba(255, 186, 96, 0.15); }
.draw-card.lv-1 .card-level { background: linear-gradient(120deg, #ffd89a, #ff9f43); color: #2a1a08; font-weight: 700; }
.draw-card.lv-2 .card-front { border-color: rgba(190, 150, 255, 0.7); box-shadow: 0 0 18px rgba(170, 120, 255, 0.35); }
.draw-card.lv-2 .card-level { background: rgba(170, 120, 255, 0.28); color: #e2ccff; }
.draw-card.lv-3 .card-front { border-color: rgba(120, 200, 255, 0.6); }
.draw-card.lv-3 .card-level { background: rgba(80, 170, 255, 0.25); color: #cbe8ff; }
.draw-card.legend { animation: legendPulse 1.6s ease-in-out 0.9s infinite; }
@keyframes frontIn {
  0% { opacity: 0; transform: translateY(16px) scale(0.9) rotate(2deg); }
  60% { opacity: 1; }
  100% { opacity: 1; transform: translateY(0) scale(1) rotate(0deg); }
}
@keyframes backOut {
  0% { opacity: 1; transform: scale(1); }
  100% { opacity: 0; transform: scale(1.08); }
}
@keyframes legendPulse {
  0%, 100% { filter: drop-shadow(0 0 0 rgba(255, 186, 96, 0)); }
  50% { filter: drop-shadow(0 0 18px rgba(255, 186, 96, 0.55)); }
}

/* 彩带 */
.draw-confetti { position: absolute; inset: -40px 0 auto; height: 60%; pointer-events: none; overflow: hidden; }
.draw-confetti span {
  position: absolute;
  top: -10px;
  border-radius: 2px;
  background: linear-gradient(180deg, #ffd89a, #ff9f43);
  opacity: 0;
  animation-name: confettiFall;
  animation-timing-function: ease-in;
  animation-iteration-count: 1;
  animation-fill-mode: forwards;
}
@keyframes confettiFall {
  0% { opacity: 0; transform: translateY(0) rotate(0deg); }
  15% { opacity: 1; }
  100% { opacity: 0; transform: translateY(320px) rotate(260deg); }
}

.draw-actions { display: flex; justify-content: center; gap: 14px; margin-top: 26px; }
.draw-btn {
  padding: 10px 24px;
  border-radius: 999px;
  font-size: 14px;
  cursor: pointer;
  border: 1px solid transparent;
  transition: transform 0.2s ease, background 0.2s ease;
}
.draw-btn:hover { transform: translateY(-1px); }
.draw-btn.primary { background: linear-gradient(120deg, #ffd89a, #ff9f43); color: #2a1a08; font-weight: 600; }
.draw-btn.ghost { background: transparent; border-color: rgba(246, 239, 230, 0.28); color: rgba(246, 239, 230, 0.85); }

@keyframes vignettePulse { 0%, 100% { opacity: 0.65; } 50% { opacity: 1; } }

.draw-fade-enter-active, .draw-fade-leave-active { transition: opacity 0.25s ease; }
.draw-fade-enter-from, .draw-fade-leave-to { opacity: 0; }

@media (max-width: 720px) {
  .draw-card { width: calc(50% - 8px); height: 190px; }
  .draw-cards.single .draw-card { width: min(240px, 80vw); height: 300px; }
  .draw-reel { height: 120px; }
  .reel-cell { width: 84px; height: 84px; }
}
</style>
