import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './assets/css/variables.css'
import './assets/css/global.css'
import './assets/css/theme.css'
import App from './App.vue'
import router from './router'
createApp(App).use(createPinia()).use(router).mount('#app')
