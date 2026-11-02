import { createApp } from 'vue'
import { createPinia } from 'pinia'
// ElMessage / ElMessageBox / v-loading 是 JS 命令式调用,unplugin 按需导入不会带上其样式,手动补齐
import 'element-plus/es/components/message/style/css'
import 'element-plus/es/components/message-box/style/css'
import 'element-plus/es/components/loading/style/css'
import './assets/css/variables.css'
import './assets/css/global.css'
import './assets/css/theme.css'
import App from './App.vue'
import router from './router'
createApp(App).use(createPinia()).use(router).mount('#app')
