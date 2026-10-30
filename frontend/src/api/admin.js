import request from './request'
export const adminAlbums = params => request.get('/admin/albums', { params })
export const saveAlbum = (id, body) => id ? request.put(`/admin/albums/${id}`, body) : request.post('/admin/albums', body)
export const albumStatus = (id, status) => request.put(`/admin/albums/${id}/status`, null, { params: { status } })
export const adminSongs = params => request.get('/admin/songs', { params })
export const saveSong = (id, body) => id ? request.put(`/admin/songs/${id}`, body) : request.post('/admin/songs', body)
export const adminUsers = params => request.get('/admin/users', { params })
export const userStatus = (id, status) => request.put(`/admin/users/${id}/status`, { status })
export const userRole = (id, role) => request.put(`/admin/users/${id}/role`, { role })
export const pendingRefunds = params => request.get('/refund/admin/pending', { params })
export const reviewRefund = (id, body) => request.put(`/refund/admin/${id}/review`, body)
export const shipOrder = (no, body) => request.put(`/order/ship/${encodeURIComponent(no)}`, body)
export const uploadMedia = (kind, file) => { const body = new FormData(); body.append('file', file); return request.post(`/admin/media/${kind}`, body) }
