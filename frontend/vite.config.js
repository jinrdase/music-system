import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'
// BACKEND_PORT 可把代理指向另一端口的后端实例（如并行验证 8081），默认 8080
const backend = `http://localhost:${process.env.BACKEND_PORT || 8080}`
export default defineConfig({ plugins: [vue(), Components({ resolvers: [ElementPlusResolver({ importStyle: 'css' })] })], server: { port: 5173, proxy: { '/api': { target: backend, changeOrigin: true }, '/media': { target: backend, changeOrigin: true } } } })
