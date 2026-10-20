import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'
export default defineConfig({ plugins: [vue(), Components({ resolvers: [ElementPlusResolver({ importStyle: 'css' })] })], server: { port: 5173, proxy: { '/api': { target: 'http://localhost:8080', changeOrigin: true }, '/media': { target: 'http://localhost:8080', changeOrigin: true } } } })
