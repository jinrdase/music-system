import request from './request'
export const login = payload => request.post('/user/login', payload)
export const register = payload => request.post('/user/register', payload)
export const userInfo = () => request.get('/user/info')
export const updateProfile = payload => request.put('/user/profile', payload)
export const changePassword = payload => request.put('/user/password', payload)
export const uploadAvatar = file => { const data = new FormData(); data.append('file', file); return request.post('/user/avatar', data) }
