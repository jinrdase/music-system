import request from './request'
export const cart = () => request.get('/cart/list')
export const addCart = payload => request.post('/cart/add', payload)
export const changeQuantity = (id, quantity) => request.put(`/cart/updateQuantity/${id}`, null, { params: { quantity } })
export const selectCart = (id, isSelected) => request.put(`/cart/toggleSelect/${id}`, null, { params: { isSelected } })
export const selectAllCart = isSelected => request.put('/cart/toggleSelectAll', null, { params: { isSelected } })
export const removeCart = id => request.delete(`/cart/remove/${id}`)
export const clearCart = () => request.delete('/cart/clear')
