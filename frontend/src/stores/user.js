import { defineStore } from 'pinia'
import { login as loginApi, userInfo } from '../api/auth'
export const useUserStore = defineStore('user', {
  state: () => ({ token: localStorage.getItem('music-token') || '', user: JSON.parse(localStorage.getItem('music-user') || 'null') }),
  getters: { isLoggedIn: s => Boolean(s.token), isAdmin: s => ['admin', 'super_admin'].includes(String(s.user?.role || '').toLowerCase()) },
  actions: {
    async login(form) { const result = await loginApi(form); if (!result?.token || !result?.userInfo) throw new Error('登录响应缺少 token 或 userInfo，未保存登录状态'); this.token = result.token; this.user = result.userInfo; localStorage.setItem('music-token', this.token); localStorage.setItem('music-user', JSON.stringify(this.user)); return this.user },
    async refreshUser() { const user = await userInfo(); this.user = user; localStorage.setItem('music-user', JSON.stringify(user)); return user },
    logout() { this.token = ''; this.user = null; localStorage.removeItem('music-token'); localStorage.removeItem('music-user') }
  }
})
