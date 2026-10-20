import { defineStore } from 'pinia'
import { login as loginApi, userInfo } from '../api/auth'
export const useUserStore = defineStore('user', {
  state: () => ({ token: sessionStorage.getItem('music-token') || '', user: JSON.parse(sessionStorage.getItem('music-user') || 'null') }),
  getters: { isLoggedIn: s => Boolean(s.token), isAdmin: s => ['admin', 'super_admin'].includes(String(s.user?.role || '').toLowerCase()) },
  actions: {
    async login(form) { const result = await loginApi(form); if (!result?.token || !result?.userInfo) throw new Error('登录响应缺少 token 或 userInfo，未保存登录状态'); this.token = result.token; this.user = result.userInfo; sessionStorage.setItem('music-token', this.token); sessionStorage.setItem('music-user', JSON.stringify(this.user)); return this.user },
    async refreshUser() { const user = await userInfo(); this.user = user; sessionStorage.setItem('music-user', JSON.stringify(user)); return user },
    logout() { this.token = ''; this.user = null; sessionStorage.removeItem('music-token'); sessionStorage.removeItem('music-user') }
  }
})
