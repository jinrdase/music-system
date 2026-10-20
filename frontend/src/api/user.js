import request from './request'
export const addresses = () => request.get('/address/list')
export const addAddress = payload => request.post('/address/add', payload)
export const updateAddress = (id, payload) => request.put(`/address/update/${id}`, payload)
export const deleteAddress = id => request.delete(`/address/delete/${id}`)
export const setDefaultAddress = id => request.put(`/address/setDefault/${id}`)
