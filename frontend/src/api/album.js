import request from './request'
export const albums = params => request.get('/album/list', { params })
export const albumDetail = id => request.get(`/album/${id}`)
export const countPlay = songId => request.post(`/album/song/${songId}/play`)
