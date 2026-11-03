<script setup>
import { ref, reactive, nextTick, onUnmounted, watch } from 'vue'
import { useUserStore } from '../stores/user'
import request from '../api/request'

const user = useUserStore()
const open = ref(false)
const input = ref('')
const streaming = ref(false)
const messages = ref([])
const listRef = ref(null)
const firstOpen = ref(true)
let abortController = null

const WELCOME = '你好，我是 PP 音乐购物助手 🎧\n可以帮你：查专辑/盲盒商品、查订单与支付状态、查退款进度、看购物车。\n试试问我"有什么专辑"或"我的订单到哪了"'

function toggleOpen() {
  open.value = !open.value
  if (open.value && firstOpen.value) {
    firstOpen.value = false
    messages.value.push({ role: 'assistant', text: WELCOME })
  }
  if (open.value) scrollToBottom()
}

function scrollToBottom() {
  nextTick(() => {
    if (listRef.value) listRef.value.scrollTop = listRef.value.scrollHeight
  })
}

function handleKeydown(event) {
  if (event.key === 'Enter' && !event.shiftKey) {
    event.preventDefault()
    send()
  }
}

async function send() {
  const text = input.value.trim()
  if (!text || streaming.value) return
  input.value = ''
  messages.value.push({ role: 'user', text })
  const reply = reactive({ role: 'assistant', text: '' })
  messages.value.push(reply)
  scrollToBottom()

  streaming.value = true
  abortController = new AbortController()
  try {
    const response = await fetch('/api/ai/chat/stream', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${user.token}` },
      body: JSON.stringify({ message: text }),
      signal: abortController.signal
    })
    if (!response.ok) throw new Error(`请求失败（${response.status}）`)
    await readSseStream(response.body, chunk => {
      reply.text += chunk
      scrollToBottom()
    })
    if (!reply.text) reply.text = '[AI 未返回内容，请重试]'
  } catch (error) {
    if (error.name === 'AbortError') {
      reply.text += '\n[已停止生成]'
    } else {
      reply.text = `抱歉，AI 助手暂时不可用（${error.message}），请稍后再试`
    }
  } finally {
    streaming.value = false
    abortController = null
    scrollToBottom()
  }
}

/** 解析 SSE：事件间以空行分隔，同一事件内多行 data: 以换行拼接 */
async function readSseStream(body, onChunk) {
  const reader = body.getReader()
  const decoder = new TextDecoder('utf-8')
  let buffer = ''
  for (;;) {
    const { done, value } = await reader.read()
    if (done) break
    buffer += decoder.decode(value, { stream: true })
    let separator
    while ((separator = buffer.indexOf('\n\n')) !== -1) {
      const event = buffer.slice(0, separator)
      buffer = buffer.slice(separator + 2)
      const data = event.split('\n')
        .filter(line => line.startsWith('data:'))
        .map(line => line.slice(5))
        .join('\n')
      if (data) onChunk(data)
    }
  }
}

function stopStream() {
  abortController?.abort()
}

async function clearConversation() {
  try {
    await request.post('/ai/chat/clear', {}, { silent: true })
    messages.value = [{ role: 'assistant', text: WELCOME }]
    firstOpen.value = false
  } catch (error) {
    // silent 请求失败不弹全局提示，仅保持现状
  }
}

watch(() => user.isLoggedIn, loggedIn => {
  if (!loggedIn) {
    open.value = false
    messages.value = []
    firstOpen.value = true
  }
})

onUnmounted(() => abortController?.abort())
</script>

<template>
  <template v-if="user.isLoggedIn">
    <div v-if="open" class="ai-panel">
      <header class="ai-panel-head">
        <span class="ai-panel-title">PP 购物助手</span>
        <span class="ai-panel-actions">
          <button class="ai-icon-btn" title="清空会话" @click="clearConversation">⟲</button>
          <button class="ai-icon-btn" title="收起" @click="open = false">✕</button>
        </span>
      </header>
      <div ref="listRef" class="ai-msg-list">
        <div v-for="(msg, index) in messages" :key="index" class="ai-msg" :class="msg.role">
          <div class="ai-bubble">{{ msg.text }}</div>
        </div>
        <div v-if="streaming" class="ai-typing">正在输入…</div>
      </div>
      <footer class="ai-panel-foot">
        <textarea
          v-model="input"
          class="ai-input"
          rows="2"
          placeholder="输入问题，Enter 发送 / Shift+Enter 换行"
          :disabled="streaming"
          @keydown="handleKeydown"
        />
        <button v-if="streaming" class="ai-send stop" @click="stopStream">停止</button>
        <button v-else class="ai-send" :disabled="!input.trim()" @click="send">发送</button>
      </footer>
    </div>
    <button class="ai-fab" title="AI 购物助手" @click="toggleOpen">
      <span v-if="open">✕</span>
      <span v-else>AI</span>
    </button>
  </template>
</template>

<style scoped>
.ai-fab {
  position: fixed;
  right: 26px;
  bottom: 26px;
  z-index: 1200;
  width: 52px;
  height: 52px;
  border-radius: 50%;
  border: 1px solid var(--accent-border);
  background: linear-gradient(135deg, var(--accent), var(--accent-bright));
  color: var(--on-accent);
  font-family: var(--mono);
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  box-shadow: 0 8px 28px rgba(0, 0, 0, .35);
  transition: transform .15s ease;
}
.ai-fab:hover { transform: translateY(-2px); }

.ai-panel {
  position: fixed;
  right: 26px;
  bottom: 92px;
  z-index: 1200;
  width: 380px;
  height: 560px;
  max-height: calc(100vh - 130px);
  display: flex;
  flex-direction: column;
  border-radius: var(--radius-lg);
  border: 1px solid var(--glass-border);
  background: var(--glass);
  backdrop-filter: blur(var(--blur));
  -webkit-backdrop-filter: blur(var(--blur));
  box-shadow: var(--el-box-shadow);
  overflow: hidden;
}

.ai-panel-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  border-bottom: 1px solid var(--line);
}
.ai-panel-title { font-weight: 600; letter-spacing: .5px; }
.ai-panel-actions { display: flex; gap: 8px; }
.ai-icon-btn {
  width: 26px;
  height: 26px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: var(--glass);
  color: var(--muted);
  cursor: pointer;
  font-size: 13px;
}
.ai-icon-btn:hover { color: var(--text); border-color: var(--glass-border); }

.ai-msg-list {
  flex: 1;
  overflow-y: auto;
  padding: 14px 16px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.ai-msg { display: flex; }
.ai-msg.user { justify-content: flex-end; }
.ai-bubble {
  max-width: 82%;
  padding: 8px 12px;
  border-radius: var(--radius);
  font-size: 13.5px;
  line-height: 1.65;
  white-space: pre-wrap;
  word-break: break-word;
}
.ai-msg.assistant .ai-bubble {
  background: var(--glass-strong);
  border: 1px solid var(--glass-border);
  border-top-left-radius: 4px;
}
.ai-msg.user .ai-bubble {
  background: var(--accent-soft);
  border: 1px solid var(--accent-border);
  border-top-right-radius: 4px;
}
.ai-typing {
  color: var(--muted);
  font-size: 12px;
  font-family: var(--mono);
  padding-left: 2px;
}

.ai-panel-foot {
  display: flex;
  gap: 8px;
  padding: 12px 16px;
  border-top: 1px solid var(--line);
  align-items: flex-end;
}
.ai-input {
  flex: 1;
  resize: none;
  background: var(--glass);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  color: var(--text);
  padding: 8px 10px;
  font-size: 13px;
  font-family: inherit;
  line-height: 1.5;
}
.ai-input:focus { outline: none; border-color: var(--accent-border); }
.ai-send {
  padding: 9px 16px;
  border-radius: var(--radius);
  border: 1px solid var(--accent-border);
  background: var(--accent-soft);
  color: var(--accent-text);
  font-size: 13px;
  cursor: pointer;
}
.ai-send:disabled { opacity: .45; cursor: not-allowed; }
.ai-send.stop {
  border-color: var(--el-border-color);
  background: var(--glass-strong);
  color: var(--text);
}
</style>
