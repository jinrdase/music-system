import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'
const routes = [
  { path: '/login', component: () => import('../views/auth/LoginView.vue'), meta: { guest: true } },
  { path: '/register', component: () => import('../views/auth/RegisterView.vue'), meta: { guest: true } },
  { path: '/', component: () => import('../layouts/MainLayout.vue'), children: [
    { path: '', component: () => import('../views/home/HomeView.vue') },
    { path: 'albums/:id', component: () => import('../views/album/AlbumDetailView.vue') },
    { path: 'cart', component: () => import('../views/cart/CartView.vue'), meta: { auth: true } },
    { path: 'orders', component: () => import('../views/order/OrderListView.vue'), meta: { auth: true } },
    { path: 'orders/:id', component: () => import('../views/order/OrderDetailView.vue'), meta: { auth: true } },
    { path: 'profile', component: () => import('../views/user/ProfileView.vue'), meta: { auth: true } },
    { path: 'addresses', component: () => import('../views/user/AddressView.vue'), meta: { auth: true } },
    { path: 'refunds', component: () => import('../views/user/RefundView.vue'), meta: { auth: true } },
    { path: 'blindboxes', component: () => import('../views/blindbox/BlindboxView.vue') }
  ] },
  { path: '/admin', component: () => import('../layouts/AdminLayout.vue'), meta: { auth: true, admin: true }, children: [
    { path: '', component: () => import('../views/admin/DashboardView.vue') },
    { path: 'albums', component: () => import('../views/admin/AlbumManageView.vue') },
    { path: 'songs', component: () => import('../views/admin/SongManageView.vue') },
    { path: 'blindboxes', component: () => import('../views/admin/BlindboxManageView.vue') },
    { path: 'users', component: () => import('../views/admin/UserManageView.vue') },
    { path: 'orders', component: () => import('../views/admin/OrderManageView.vue') },
  ] },
  { path: '/:pathMatch(.*)*', component: () => import('../views/NotFoundView.vue') }
]
const router = createRouter({ history: createWebHistory(), routes, scrollBehavior: () => ({ top: 0 }) })
router.beforeEach(async to => {
  const user = useUserStore()
  if (user.token && (!user.user || to.meta.admin)) { try { await user.refreshUser() } catch { user.logout() } }
  if (to.meta.auth && !user.isLoggedIn) return { path: '/login', query: { redirect: to.fullPath } }
  if (to.meta.admin && !user.isAdmin) return user.isLoggedIn ? '/' : { path: '/login', query: { redirect: to.fullPath } }
  if (to.meta.guest && user.isLoggedIn) return '/'
})
export default router
