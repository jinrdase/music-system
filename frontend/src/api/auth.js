import request from './request'
export const login = payload => request.post('/user/login', payload)
export const register = payload => request.post('/user/register', payload)
export const userInfo = () => request.get('/user/info')
