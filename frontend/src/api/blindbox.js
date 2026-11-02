import request from './request'
export const blindboxes = params => request.get('/blind-box/list', { params })
export const blindboxDetail = id => request.get(`/blind-box/${id}`)
export const drawRecords = params => request.get('/blind-box/my/records', { params })
export const createBlindboxOrder = payload => request.post('/blind-box/order', payload)
export const adminBlindboxes = params => request.get('/admin/blind-boxes', { params })
export const createBlindbox = body => request.post('/admin/blind-boxes', body)
export const changeBlindboxStatus = (id, status) => request.put(`/admin/blind-boxes/${id}/status`, null, { params: { status } })
export const adminPrizes = (id, body) => request.post(`/admin/blind-boxes/${id}/prizes`, body)
