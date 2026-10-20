import axios from 'axios'
import { ElMessage } from 'element-plus'
const request = axios.create({ baseURL: '/api', timeout: 15000 })
request.interceptors.request.use(config => { const token = sessionStorage.getItem('music-token'); if (token) config.headers.Authorization = `Bearer ${token}`; return config })
request.interceptors.response.use(response => {
  const body = response.data
  if (body && typeof body === 'object' && 'code' in body && 'data' in body) {
    if (Number(body.code) !== 200) {
      const error = new Error(body.message || '请求失败'); error.code = body.code
      if (Number(body.code) === 401) { sessionStorage.removeItem('music-token'); sessionStorage.removeItem('music-user'); if (location.pathname !== '/login') location.href = `/login?redirect=${encodeURIComponent(location.pathname)}` }
      if (!response.config?.silent) ElMessage.error(error.message)
      throw error
    }
    return body.data
  }
  return body
}, error => {
  const status = error.response?.status
  const message = status === 401 ? '登录状态已失效，请重新登录' : status === 403 ? '当前账号没有此操作权限' : error.code === 'ECONNABORTED' ? '请求超时，请稍后重试' : !error.response ? '网络连接失败，请确认后端服务已启动' : error.response?.data?.message || error.message || '请求失败'
  if (status === 401) { sessionStorage.removeItem('music-token'); sessionStorage.removeItem('music-user'); if (location.pathname !== '/login') location.href = `/login?redirect=${encodeURIComponent(location.pathname)}` }
  if (!error.config?.silent) ElMessage.error(message)
  error.message = message; return Promise.reject(error)
})
export default request
