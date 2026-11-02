(() => {
  'use strict';

  const TOKEN_KEY = 'music-system-token';
  const USER_KEY = 'music-system-user';
  const $ = (selector, root = document) => root.querySelector(selector);
  const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];
  const state = {
    token: sessionStorage.getItem(TOKEN_KEY),
    user: (() => { try { return JSON.parse(sessionStorage.getItem(USER_KEY) || 'null'); } catch (_) { return null; } })(),
    page: 'home',
    albums: [],
    addresses: [],
    paymentTimer: null
  };

  const escapeHtml = value => String(value ?? '').replace(/[&<>"']/g, char => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  })[char]);
  const safeUrl = value => {
    const raw = String(value || '').trim();
    if (!raw) return '';
    try {
      const url = new URL(raw, window.location.origin);
      return ['http:', 'https:'].includes(url.protocol) ? url.href : '';
    } catch (_) { return ''; }
  };
  const money = value => Number(value || 0).toFixed(2);
  const listFrom = value => Array.isArray(value) ? value : [];
  const pageRecords = value => Array.isArray(value?.records) ? value.records : [];
  const isAdmin = () => ['admin', 'super_admin'].includes(String(state.user?.role || '').toLowerCase());

  function notify(message, type = 'info') {
    const toast = $('#toast');
    if (!toast) return;
    toast.textContent = message;
    toast.className = `toast show${type === 'error' ? ' error' : ''}`;
    clearTimeout(notify.timer);
    notify.timer = setTimeout(() => { toast.className = 'toast'; }, 3600);
  }

  async function api(path, options = {}) {
    const headers = new Headers(options.headers || {});
    if (state.token) headers.set('Authorization', `Bearer ${state.token}`);
    if (options.body && !(options.body instanceof FormData) && !headers.has('Content-Type')) {
      headers.set('Content-Type', 'application/json');
    }
    let response;
    try {
      response = await fetch(path, { ...options, headers });
    } catch (_) {
      throw new Error('无法连接服务，请确认后端已在 localhost:8080 启动。');
    }
    const raw = await response.text();
    let payload = {};
    try { payload = raw ? JSON.parse(raw) : {}; } catch (_) { payload = { message: raw }; }
    if (response.status === 401 && state.token) {
      clearSession();
      renderSession();
    }
    if (!response.ok || (payload.code !== undefined && Number(payload.code) !== 200)) {
      throw new Error(payload.message || payload.msg || `请求失败（HTTP ${response.status}）`);
    }
    return payload.data !== undefined ? payload.data : payload;
  }

  function clearSession() {
    state.token = null;
    state.user = null;
    sessionStorage.removeItem(TOKEN_KEY);
    sessionStorage.removeItem(USER_KEY);
  }

  function renderSession() {
    const loggedIn = Boolean(state.token);
    $('#auth-screen').classList.toggle('hidden', loggedIn);
    $('#workspace').classList.toggle('hidden', !loggedIn);
    $('#account-label').textContent = loggedIn ? (state.user?.nickname || state.user?.username || '已登录') : '登录 / 注册';
    $('#account-avatar').textContent = loggedIn ? (state.user?.nickname || state.user?.username || '♪').slice(0, 1).toUpperCase() : '♪';
    $$('.sidebar-admin').forEach(node => node.classList.toggle('hidden', !isAdmin()));
    if (loggedIn) {
      loadAlbums();
      loadCartCount();
    }
  }

  function authMode(mode) {
    const registering = mode === 'register';
    $('#login-form').classList.toggle('hidden', registering);
    $('#register-form').classList.toggle('hidden', !registering);
    $$('.auth-tab').forEach(tab => tab.classList.toggle('active', tab.dataset.authTab === mode));
    $('#auth-eyebrow').textContent = registering ? 'JOIN THE COLLECTION' : 'SIGN IN';
    $('#auth-title').textContent = registering ? '创建你的账号' : '登录你的账号';
    $('#auth-subtitle').textContent = registering ? '注册后即可开始收藏喜欢的专辑。' : '继续探索你的音乐收藏。';
  }

  $('#login-form').addEventListener('submit', async event => {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    try {
      const data = await api('/api/user/login', {
        method: 'POST', body: JSON.stringify({ username: form.get('username'), password: form.get('password') })
      });
      state.token = data.token;
      state.user = data.userInfo || {};
      sessionStorage.setItem(TOKEN_KEY, state.token);
      sessionStorage.setItem(USER_KEY, JSON.stringify(state.user));
      renderSession();
      notify(`欢迎回来，${state.user.nickname || state.user.username || '音乐朋友'}。`);
    } catch (error) { notify(error.message, 'error'); }
  });

  $('#register-form').addEventListener('submit', async event => {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    if (form.get('password') !== form.get('confirmPassword')) return notify('两次输入的密码不一致。', 'error');
    const body = Object.fromEntries(form.entries());
    for (const key of ['phone', 'email', 'nickname']) if (!body[key]) body[key] = null;
    try {
      const data = await api('/api/user/register', { method: 'POST', body: JSON.stringify(body) });
      event.currentTarget.reset();
      authMode('login');
      $('#login-form [name="username"]').value = body.username;
      notify(`注册成功${data?.id ? `，用户编号 ${data.id}` : ''}，请登录。`);
    } catch (error) { notify(error.message, 'error'); }
  });

  function openPage(page) {
    if (!state.token) return authMode('login');
    if (page === 'admin' && !isAdmin()) return notify('当前账号没有后台访问权限。', 'error');
    state.page = page;
    $$('.page').forEach(section => section.classList.toggle('active', section.id === `page-${page}`));
    $$('.nav-item[data-page]').forEach(button => button.classList.toggle('active', button.dataset.page === page));
    $('#sidebar').classList.remove('open');
    location.hash = page;
    const loaders = {
      home: loadAlbums, cart: loadCart, orders: loadOrders, profile: loadProfile, addresses: loadAddresses,
      refunds: loadRefunds, blindboxes: loadBlindboxes, admin: loadAdminPage
    };
    loaders[page]?.();
  }

  $$('.nav-item[data-page]').forEach(button => button.addEventListener('click', () => openPage(button.dataset.page)));
  $('#menu-toggle').addEventListener('click', () => $('#sidebar').classList.toggle('open'));
  $('#account-button').addEventListener('click', () => {
    if (state.token) openPage('home'); else { $('#auth-screen').classList.remove('hidden'); $('#workspace').classList.add('hidden'); }
  });
  $('#logout-button').addEventListener('click', () => { clearSession(); renderSession(); notify('已退出登录。'); });
  $$('.auth-tab').forEach(button => button.addEventListener('click', () => authMode(button.dataset.authTab)));

  async function loadAlbums() {
    const grid = $('#album-grid');
    grid.innerHTML = '<div class="loading-card">正在加载专辑…</div>';
    const keyword = $('#album-search').value.trim() || $('#global-search').value.trim();
    const params = new URLSearchParams({ current: '1', size: '60' });
    if (keyword) params.set('keyword', keyword);
    try {
      const data = await api(`/api/album/list?${params}`);
      state.albums = pageRecords(data).filter(album => {
        const filter = $('#product-filter').value;
        return !filter || String(album.productType || 'PHYSICAL').toUpperCase() === filter;
      });
      grid.innerHTML = state.albums.length ? state.albums.map(albumCard).join('') : '<div class="empty-state">没有找到符合条件的专辑，试试其他关键词。</div>';
    } catch (error) {
      grid.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`;
    }
  }

  function albumCard(album) {
    const type = String(album.productType || 'PHYSICAL').toUpperCase();
    const cover = safeUrl(album.coverUrl);
    return `<article class="album-card">
      ${cover ? `<img class="album-cover" loading="lazy" src="${escapeHtml(cover)}" alt="${escapeHtml(album.title)}封面">` : '<div class="album-cover cover-fallback" aria-label="专辑封面">♫</div>'}
      <div class="album-card-body"><div class="row"><span class="tag ${type === 'DIGITAL' ? 'digital' : ''}">${type === 'DIGITAL' ? '数字专辑' : '实体专辑'}</span>${album.isLimited ? '<span class="tag">限量</span>' : ''}</div>
        <h3 title="${escapeHtml(album.title)}">${escapeHtml(album.title || '未命名专辑')}</h3><p class="album-artist">${escapeHtml(album.artist || '未知艺人')}</p>
        <div class="album-meta"><span class="price">¥${money(album.price)}</span><span>库存 ${Number(album.stock || 0)}</span></div>
        <div class="card-actions"><button class="button outline" data-action="detail" data-id="${Number(album.id)}">详情</button><button class="button outline" data-action="cart-add" data-id="${Number(album.id)}">加购物车</button><button class="button primary" data-action="buy" data-id="${Number(album.id)}">购买</button></div>
      </div></article>`;
  }

  $('#search-button').addEventListener('click', loadAlbums);
  $('#refresh-albums').addEventListener('click', loadAlbums);
  $('#product-filter').addEventListener('change', loadAlbums);
  $('#album-search').addEventListener('keydown', event => { if (event.key === 'Enter') loadAlbums(); });
  $('#global-search').addEventListener('keydown', event => {
    if (event.key === 'Enter') { $('#album-search').value = event.currentTarget.value; openPage('home'); loadAlbums(); }
  });
  $('[data-scroll-catalog]').addEventListener('click', () => $('#catalog').scrollIntoView({ behavior: 'smooth' }));

  async function showAlbum(id, checkout = false) {
    try {
      const album = await api(`/api/album/${encodeURIComponent(id)}`);
      if (checkout) return openCheckout(album);
      const cover = safeUrl(album.coverUrl);
      const songs = listFrom(album.songs);
      $('#detail-content').innerHTML = `<div class="detail-header">${cover ? `<img class="detail-cover" src="${escapeHtml(cover)}" alt="">` : '<div class="album-cover cover-fallback">♫</div>'}<div><span class="tag ${album.productType === 'DIGITAL' ? 'digital' : ''}">${album.productType === 'DIGITAL' ? '数字专辑' : '实体专辑'}</span><h2>${escapeHtml(album.title)}</h2><p>${escapeHtml(album.artist)} · ¥${money(album.price)}</p><p>${escapeHtml(album.description || '暂无专辑介绍。')}</p><button class="button primary" data-action="buy" data-id="${Number(album.id)}">购买这张专辑</button></div></div>
        <h3>曲目列表</h3>${songs.length ? songs.map(song => `<div class="track-row"><div><strong>${escapeHtml(song.trackNumber || '')}. ${escapeHtml(song.title)}</strong><small>${escapeHtml(song.artist || '')} · ${formatDuration(song.duration)}</small><small class="muted" data-audio-status role="status">${safeUrl(song.previewUrl) ? '' : '暂无试听音频，暂不可播放。'}</small></div>${safeUrl(song.previewUrl) ? `<audio controls preload="none" data-song-id="${Number(song.id)}" src="${escapeHtml(safeUrl(song.previewUrl))}"></audio>` : '<span class="muted">暂无试听</span>'}</div>`).join('') : '<p>暂无曲目信息。</p>'}`;
      $('#detail-dialog').showModal();
    } catch (error) { notify(error.message, 'error'); }
  }

  function formatDuration(seconds) {
    const n = Number(seconds || 0);
    return `${Math.floor(n / 60)}:${String(n % 60).padStart(2, '0')}`;
  }

  async function openCheckout(album) {
    const digital = String(album.productType || 'PHYSICAL').toUpperCase() === 'DIGITAL';
    let addressSelect = '';
    if (!digital) {
      const addresses = await loadAddresses(true);
      if (!addresses.length) {
        $('#checkout-dialog').close();
        notify('实物商品下单前，请先添加收货地址。');
        openPage('addresses');
        return;
      }
      addressSelect = `<label>收货地址<select id="checkout-address" required>${addresses.map(address => `<option value="${Number(address.id)}" ${Number(address.isDefault) === 1 ? 'selected' : ''}>${escapeHtml(address.receiverName)} · ${escapeHtml(address.receiverPhone)} · ${escapeHtml(address.fullAddress || [address.province, address.city, address.district, address.detailAddress].filter(Boolean).join(' '))}</option>`).join('')}</select></label>`;
    }
    $('#detail-dialog').close();
    $('#checkout-content').innerHTML = `<p class="eyebrow">CHECKOUT</p><h2>确认订单</h2><p>商品：${escapeHtml(album.title)} · ${digital ? '数字内容' : '实物商品'}</p><div class="form-stack"><label>购买数量<input id="checkout-quantity" type="number" min="1" max="${Math.max(1, Number(album.stock || 1))}" value="1"></label>${addressSelect}<label>订单备注<input id="checkout-remark" maxlength="200" placeholder="选填"></label><div class="row"><span class="price">¥${money(album.price)}</span><button class="button primary" id="confirm-checkout">创建订单</button></div><small class="muted">创建订单会占用库存。创建后请在“我的订单”完成支付。</small></div>`;
    $('#checkout-dialog').showModal();
    $('#confirm-checkout').addEventListener('click', async () => {
      const quantity = Number($('#checkout-quantity').value);
      if (!Number.isInteger(quantity) || quantity < 1) return notify('请输入有效的购买数量。', 'error');
      const body = { albumId: Number(album.id), quantity, remark: $('#checkout-remark').value.trim() || null };
      if (!digital) body.addressId = Number($('#checkout-address').value);
      try {
        const order = await api('/api/order/create', { method: 'POST', body: JSON.stringify(body) });
        $('#checkout-dialog').close();
        notify(`订单已创建：${order.orderNo || ''}`);
        openPage('orders');
      } catch (error) { notify(error.message, 'error'); }
    }, { once: true });
  }

  async function loadCartCount() {
    try {
      const cart = await api('/api/cart/list');
      const count = Number(cart.totalCount || 0);
      $('#cart-count').textContent = count > 99 ? '99+' : String(count);
    } catch (_) { $('#cart-count').textContent = '0'; }
  }

  async function loadCart() {
    const target = $('#cart-content');
    target.innerHTML = '<div class="loading-card">正在加载购物车…</div>';
    try {
      const cart = await api('/api/cart/list');
      const items = listFrom(cart.items);
      $('#cart-count').textContent = String(cart.totalCount || 0);
      if (!items.length) { target.innerHTML = '<div class="empty-state">购物车还是空的，去商店看看吧。</div>'; return; }
      target.innerHTML = `<div class="section-heading"><div><h2>已选 ${Number(cart.selectedCount || 0)} 件</h2><p class="muted">合计 ¥${money(cart.selectedAmount)}</p></div><button class="button outline" data-action="cart-select-all">${items.every(item => Number(item.isSelected) === 1) ? '取消全选' : '全选'}</button></div><div class="stack-list">${items.map(item => `<article class="list-card row"><input type="checkbox" aria-label="选择${escapeHtml(item.albumName)}" data-action="cart-toggle" data-id="${Number(item.id)}" ${Number(item.isSelected) === 1 ? 'checked' : ''}><div class="cart-item-main">${safeUrl(item.albumCover) ? `<img class="cart-thumb" src="${escapeHtml(safeUrl(item.albumCover))}" alt="">` : '<span class="cart-thumb cover-fallback">♫</span>'}<div><h3>${escapeHtml(item.albumName)}</h3><p>¥${money(item.price)} × ${Number(item.quantity)} · 小计 ¥${money(item.subtotal)}</p>${Number(item.isValid) === 0 ? '<span class="status-pill danger">商品失效</span>' : ''}</div></div><div class="row"><button class="button outline" data-action="cart-minus" data-id="${Number(item.id)}" data-quantity="${Number(item.quantity)}">−</button><span>${Number(item.quantity)}</span><button class="button outline" data-action="cart-plus" data-id="${Number(item.id)}" data-quantity="${Number(item.quantity)}">＋</button><button class="button primary" data-action="cart-checkout" data-album="${Number(item.albumId)}">单件结算</button><button class="button danger" data-action="cart-remove" data-id="${Number(item.id)}">移除</button></div></article>`).join('')}</div><div class="notice-card"><span>i</span><p>当前后端下单接口一次创建一个专辑订单，暂不支持把多件购物车商品合并结算。请逐件结算。</p></div><div class="row"><button class="button outline" data-action="cart-clear-invalid">清理失效商品</button><button class="button danger" data-action="cart-clear">清空购物车</button></div>`;
    } catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }

  async function mutateCart(path, method = 'DELETE', body) {
    try { await api(path, { method, ...(body === undefined ? {} : { body: JSON.stringify(body) }) }); await loadCart(); notify('购物车已更新。'); }
    catch (error) { notify(error.message, 'error'); }
  }

  async function loadAddresses(quiet = false) {
    try {
      state.addresses = listFrom(await api('/api/address/list'));
      if (!quiet) renderAddresses();
      return state.addresses;
    } catch (error) { if (!quiet) notify(error.message, 'error'); return []; }
  }

  function renderAddresses() {
    const target = $('#address-list');
    if (!state.addresses.length) { target.innerHTML = '<div class="empty-state">还没有收货地址。</div>'; return; }
    target.innerHTML = state.addresses.map(address => `<article class="list-card"><div class="row"><h3>${escapeHtml(address.receiverName)}</h3>${address.isDefault ? '<span class="status-pill success">默认地址</span>' : ''}</div><p>${escapeHtml(address.receiverPhone)}</p><p>${escapeHtml(address.fullAddress || [address.province, address.city, address.district, address.detailAddress].filter(Boolean).join(' '))}</p><div class="row">${!address.isDefault ? `<button class="button outline" data-action="address-default" data-id="${Number(address.id)}">设为默认</button>` : ''}<button class="button outline" data-action="address-edit" data-id="${Number(address.id)}">编辑</button><button class="button danger" data-action="address-delete" data-id="${Number(address.id)}">删除</button></div></article>`).join('');
  }

  $('#address-form').addEventListener('submit', async event => {
    event.preventDefault();
    const form = event.currentTarget;
    const body = Object.fromEntries(new FormData(form).entries());
    body.isDefault = Number(body.isDefault);
    const addressId = form.dataset.addressId;
    try {
      await api(addressId ? `/api/address/update/${addressId}` : '/api/address/add', { method: addressId ? 'PUT' : 'POST', body: JSON.stringify(body) });
      form.reset(); delete form.dataset.addressId; $('.address-layout h2')?.replaceChildren(document.createTextNode('添加新地址'));
      await loadAddresses(); notify(addressId ? '地址已更新。' : '地址已添加。');
    } catch (error) { notify(error.message, 'error'); }
  });

  async function loadOrders() {
    const target = $('#orders-content'); target.innerHTML = '<div class="loading-card">正在加载订单…</div>';
    try {
      const data = await api('/api/order/my?current=1&size=50'); const orders = pageRecords(data);
      target.innerHTML = orders.length ? orders.map(orderCard).join('') : '<div class="empty-state">还没有订单。</div>';
    } catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }

  async function loadProfile() {
    const target = $('#profile-content'); target.innerHTML = '<div class="loading-card">正在加载账号资料…</div>';
    try {
      const user = await api('/api/user/info');
      state.user = user; sessionStorage.setItem(USER_KEY, JSON.stringify(user));
      $('#account-label').textContent = user.nickname || user.username || '已登录';
      target.innerHTML = `<div class="profile-card"><div class="profile-avatar">${escapeHtml((user.nickname || user.username || '♪').slice(0, 1).toUpperCase())}</div><div><p class="eyebrow">MEMBER PROFILE</p><h2>${escapeHtml(user.nickname || user.username)}</h2><span class="status-pill ${Number(user.status) === 1 ? 'success' : 'danger'}">${Number(user.status) === 1 ? '账号正常' : '账号受限'}</span></div></div><dl class="profile-grid"><div><dt>用户编号</dt><dd>${Number(user.id)}</dd></div><div><dt>用户名</dt><dd>${escapeHtml(user.username)}</dd></div><div><dt>角色</dt><dd>${escapeHtml(user.role || 'user')}</dd></div><div><dt>手机号</dt><dd>${escapeHtml(user.phone || '未填写')}</dd></div><div><dt>邮箱</dt><dd>${escapeHtml(user.email || '未填写')}</dd></div><div><dt>注册时间</dt><dd>${escapeHtml(user.createTime || '—')}</dd></div></dl><div class="notice-card"><span>i</span><p>当前后端仅提供账号信息查询，没有个人资料更新或头像修改接口。</p></div>`;
    } catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }

  function statusLabel(order) {
    const labels = { 0: ['待支付', 'warn'], 1: ['已支付', 'success'], 2: ['已完成', 'success'], 3: ['已取消', 'danger'], 4: ['已发货', ''] };
    return labels[order.status] || [order.statusText || '处理中', ''];
  }

  function orderCard(order) {
    const [status, tone] = statusLabel(order);
    const cover = safeUrl(order.albumCover);
    return `<article class="list-card order-card"><div class="row order-title"><div><p class="eyebrow">ORDER ${escapeHtml(order.orderNo)}</p><h3>${escapeHtml(order.albumTitle || '专辑订单')}</h3></div><span class="status-pill ${tone}">${escapeHtml(status)}</span></div><p>${escapeHtml(order.productType || '')} · ${Number(order.quantity)} 件 · ¥${money(order.totalAmount)}</p>${order.carrier ? `<p>物流：${escapeHtml(order.carrier)} · ${escapeHtml(order.trackingNo)}</p>` : ''}<div class="row">${cover ? `<img class="order-cover" src="${escapeHtml(cover)}" alt="">` : ''}<button class="button outline" data-action="order-detail" data-order="${escapeHtml(order.orderNo)}">订单详情</button>${Number(order.status) === 0 ? `<button class="button primary" data-action="order-pay" data-id="${Number(order.id)}" data-order="${escapeHtml(order.orderNo)}">去支付</button><button class="button danger" data-action="order-cancel" data-order="${escapeHtml(order.orderNo)}">取消订单</button>` : ''}${Number(order.status) === 4 ? `<button class="button primary" data-action="order-receive" data-order="${escapeHtml(order.orderNo)}">确认收货</button>` : ''}${String(order.productType).toUpperCase() === 'DIGITAL' && [1, 2].includes(Number(order.status)) ? `<button class="button outline" data-action="digital-content" data-order="${escapeHtml(order.orderNo)}">获取数字内容</button>` : ''}${[1, 2, 4].includes(Number(order.status)) ? `<button class="button outline" data-action="refund-apply" data-id="${Number(order.id)}">申请退款</button>` : ''}</div></article>`;
  }

  async function startPayment(orderId, orderNo) {
    const method = window.prompt('选择支付方式：输入 1 使用微信支付演示，输入 2 使用支付宝演示。当前后端返回模拟支付地址，不能进行真实扣款。', '1');
    if (!['1', '2'].includes(method)) return;
    try {
      const payment = await api('/api/payment/create', { method: 'POST', body: JSON.stringify({ orderId: Number(orderId), paymentMethod: Number(method) }) });
      const destination = payment.payUrl || payment.qrCodeUrl || '';
      $('#payment-content').innerHTML = `<p class="eyebrow">PAYMENT DEMO</p><h2>支付单已创建</h2><p>订单 ${escapeHtml(payment.orderNo || orderNo)} · ¥${money(payment.amount)}</p><p>支付流水：<code>${escapeHtml(payment.paymentNo)}</code></p><div class="notice-card"><span>!</span><p>当前服务端支付地址是模拟值。请勿向真实支付页面或账号付款。</p></div>${destination ? `<label class="form-stack">模拟支付地址<code class="url-code">${escapeHtml(destination)}</code></label>` : ''}<div class="row"><button class="button outline" data-action="payment-query" data-payment="${escapeHtml(payment.paymentNo)}">查询支付状态</button><button class="button danger" data-action="payment-cancel" data-payment="${escapeHtml(payment.paymentNo)}">取消支付</button></div>`;
      $('#payment-dialog').showModal();
    } catch (error) { notify(error.message, 'error'); }
  }

  async function loadRefunds() {
    const target = $('#refunds-content'); target.innerHTML = '<div class="loading-card">正在加载退款申请…</div>';
    try {
      const data = await api('/api/refund/my?current=1&size=50'); const records = pageRecords(data);
      const labels = { 0: '待审核', 1: '已通过', 2: '已拒绝', 3: '已退款' };
      target.innerHTML = records.length ? records.map(record => `<article class="list-card"><div class="row"><h3>订单 ${escapeHtml(record.orderNo)}</h3><span class="status-pill">${escapeHtml(labels[record.status] || `状态 ${record.status}`)}</span></div><p>申请金额 ¥${money(record.refundAmount)} · ${escapeHtml(record.reason)}</p><p>${escapeHtml(record.description || '')}</p>${record.auditRemark ? `<p>审核备注：${escapeHtml(record.auditRemark)}</p>` : ''}</article>`).join('') : '<div class="empty-state">暂无退款申请。</div>';
    } catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
    $('#pending-refunds-panel').classList.toggle('hidden', !isAdmin());
    if (isAdmin()) loadPendingRefunds();
  }

  async function applyRefund(orderId) {
    const reason = window.prompt('请填写退款原因'); if (!reason?.trim()) return;
    const description = window.prompt('补充说明（选填）') || '';
    try { await api('/api/refund/apply', { method: 'POST', body: JSON.stringify({ orderId: Number(orderId), reason: reason.trim(), description }) }); notify('退款申请已提交。'); openPage('refunds'); }
    catch (error) { notify(error.message, 'error'); }
  }

  async function loadPendingRefunds() {
    const target = $('#pending-refunds'); target.innerHTML = '<div class="loading-card">正在加载…</div>';
    try {
      const data = await api('/api/refund/admin/pending?current=1&size=50'); const records = pageRecords(data);
      target.innerHTML = records.length ? records.map(record => `<article class="list-card"><h3>订单 ${escapeHtml(record.orderNo)} · 用户 ${Number(record.userId)}</h3><p>申请金额 ¥${money(record.refundAmount)} · ${escapeHtml(record.reason)}</p><p>${escapeHtml(record.description || '')}</p><div class="row"><button class="button primary" data-action="refund-review" data-id="${Number(record.id)}" data-approved="true">通过</button><button class="button danger" data-action="refund-review" data-id="${Number(record.id)}" data-approved="false">拒绝</button></div></article>`).join('') : '<div class="empty-state">当前没有待审核申请。</div>';
    } catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }

  async function loadBlindboxes() {
    $('#box-grid').innerHTML = '<div class="loading-card">正在加载盲盒…</div>';
    try {
      const data = await api('/api/blind-box/list?current=1&size=50'); const boxes = pageRecords(data);
      $('#box-grid').innerHTML = boxes.length ? boxes.map(box => `<article class="album-card"><div class="album-cover cover-fallback">✧</div><div class="album-card-body"><span class="tag">盲盒</span><h3>${escapeHtml(box.name)}</h3><p class="album-artist">${escapeHtml(box.description || '打开一份未知的音乐惊喜。')}</p><div class="album-meta"><span class="price">¥${money(box.price)}</span><span>剩余 ${Number(box.remainCount || 0)}</span></div><div class="card-actions"><button class="button outline" data-action="box-detail" data-id="${Number(box.id)}">详情</button></div></div></article>`).join('') : '<div class="empty-state">当前没有在售盲盒。</div>';
      const records = await api('/api/blind-box/my/records?current=1&size=30');
      const rows = pageRecords(records);
      $('#draw-records').innerHTML = rows.length ? rows.map(row => `<article class="list-card"><h3>${escapeHtml(row.prizeName || row.blindBoxName || '盲盒记录')}</h3><p>盲盒编号 ${Number(row.boxId || row.blindBoxId || 0)} · ${escapeHtml(row.createTime || '')}</p></article>`).join('') : '<div class="empty-state">暂无抽取记录。</div>';
    } catch (error) { $('#box-grid').innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }

  async function loadAdminPage() {
    if (!isAdmin()) return notify('当前账号没有后台访问权限。', 'error');
    loadAdminAlbums();
  }

  async function loadAdminAlbums() {
    const target = $('#admin-album-list'); target.innerHTML = '<div class="loading-card">正在加载…</div>';
    try {
      const data = await api('/api/admin/albums?current=1&size=50'); const records = pageRecords(data);
      target.innerHTML = records.length ? records.map(album => `<article class="list-card row"><div class="admin-record-main"><h3>${escapeHtml(album.title)}</h3><p>${escapeHtml(album.artist)} · ¥${money(album.price)} · 库存 ${Number(album.stock || 0)} · ${escapeHtml(album.productType || 'PHYSICAL')}</p></div><button class="button outline" data-action="album-edit" data-id="${Number(album.id)}">编辑</button><button class="button ${Number(album.status) === 1 ? 'danger' : 'primary'}" data-action="album-status" data-id="${Number(album.id)}" data-status="${Number(album.status) === 1 ? 0 : 1}">${Number(album.status) === 1 ? '下架' : '上架'}</button></article>`).join('') : '<div class="empty-state">暂无专辑。</div>';
    } catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }

  $('#album-admin-form').addEventListener('submit', async event => {
    event.preventDefault(); const form = event.currentTarget; const values = Object.fromEntries(new FormData(form).entries());
    const id = values.id; delete values.id;
    values.price = Number(values.price); values.stock = Number(values.stock); values.status = Number(values.status); values.isLimited = Number(values.isLimited);
    for (const key of ['coverUrl', 'digitalContentUrl', 'description', 'releaseDate']) if (!values[key]) values[key] = null;
    try {
      const result = await api(id ? `/api/admin/albums/${id}` : '/api/admin/albums', { method: id ? 'PUT' : 'POST', body: JSON.stringify(values) });
      notify(id ? '专辑信息已更新。' : `专辑已创建，编号 ${result}`); resetAlbumForm(); loadAdminAlbums();
    } catch (error) { notify(error.message, 'error'); }
  });

  function resetAlbumForm() { $('#album-admin-form').reset(); $('#album-admin-form [name="id"]').value = ''; $('#album-form-title').textContent = '创建专辑'; }
  $('#album-form-reset').addEventListener('click', resetAlbumForm);
  $('#album-admin-form [name="productType"]').addEventListener('change', event => $('.digital-field').classList.toggle('hidden', event.target.value !== 'DIGITAL'));
  $('#admin-album-refresh').addEventListener('click', loadAdminAlbums);

  async function editAlbum(id) {
    try {
      const album = await api(`/api/album/${id}`); const form = $('#album-admin-form');
      for (const key of ['id', 'title', 'artist', 'price', 'stock', 'productType', 'releaseDate', 'status', 'isLimited', 'coverUrl', 'digitalContentUrl', 'description']) {
        const input = form.elements.namedItem(key); if (input) input.value = album[key] ?? '';
      }
      $('#album-form-title').textContent = `编辑专辑 #${id}`;
      $('.digital-field').classList.toggle('hidden', album.productType !== 'DIGITAL');
      form.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } catch (error) { notify(error.message, 'error'); }
  }

  $('#song-admin-form').addEventListener('submit', async event => {
    event.preventDefault(); const values = Object.fromEntries(new FormData(event.currentTarget).entries());
    for (const key of ['albumId', 'duration', 'previewDuration', 'trackNumber']) values[key] = values[key] === '' ? null : Number(values[key]);
    for (const key of ['audioUrl', 'previewUrl', 'lyrics']) if (!values[key]) values[key] = null;
    const songId = event.currentTarget.dataset.songId;
    try { const result = await api(songId ? `/api/admin/songs/${songId}` : '/api/admin/songs', { method: songId ? 'PUT' : 'POST', body: JSON.stringify(values) }); notify(songId ? '歌曲已更新。' : `歌曲已创建，编号 ${result}`); event.currentTarget.reset(); delete event.currentTarget.dataset.songId; $('#admin-songs form h3').textContent = '新增歌曲'; if (values.albumId) loadAdminSongs(values.albumId); }
    catch (error) { notify(error.message, 'error'); }
  });

  async function loadAdminSongs(albumId) {
    const id = albumId || window.prompt('请输入专辑编号'); if (!id) return;
    const target = $('#admin-song-list'); target.innerHTML = '<div class="loading-card">正在加载…</div>';
    try { const data = await api(`/api/admin/songs?albumId=${encodeURIComponent(id)}&current=1&size=100`); const songs = pageRecords(data); target.innerHTML = songs.length ? songs.map(song => `<article class="list-card row"><div class="admin-record-main"><h3>${Number(song.trackNumber)}. ${escapeHtml(song.title)}</h3><p>${escapeHtml(song.artist)} · ${formatDuration(song.duration)} · 播放 ${Number(song.playCount || 0)}</p></div><button class="button outline" data-action="song-edit" data-id="${Number(song.id)}" data-album="${Number(song.albumId)}">编辑</button></article>`).join('') : '<div class="empty-state">该专辑暂无歌曲。</div>'; $('#song-admin-form [name="albumId"]').value = id; }
    catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }
  $('#admin-song-refresh').addEventListener('click', () => loadAdminSongs());

  async function editSong(id, albumId) {
    try { const detail = await api(`/api/album/${albumId}`); const song = listFrom(detail.songs).find(item => Number(item.id) === Number(id)); if (!song) throw new Error('未找到歌曲详情。'); const form = $('#song-admin-form'); for (const key of ['albumId', 'title', 'artist', 'duration', 'previewUrl', 'previewDuration', 'trackNumber', 'audioUrl', 'lyrics']) form.elements.namedItem(key).value = song[key] ?? ''; form.dataset.songId = id; $('#song-admin-form h3').textContent = `编辑歌曲 #${id}`; form.scrollIntoView({ behavior: 'smooth' }); }
    catch (error) { notify(error.message, 'error'); }
  }

  async function loadAdminBoxes() {
    const target = $('#admin-box-list'); target.innerHTML = '<div class="loading-card">正在加载…</div>';
    try { const data = await api('/api/admin/blind-boxes?current=1&size=100'); const boxes = pageRecords(data); target.innerHTML = boxes.length ? boxes.map(box => `<article class="list-card row"><div class="admin-record-main"><h3>${escapeHtml(box.name)}</h3><p>#${Number(box.id)} · ¥${money(box.price)} · 库存 ${Number(box.remainCount || 0)} · ${Number(box.status) === 1 ? '上架' : '下架'}</p></div><button class="button ${Number(box.status) === 1 ? 'danger' : 'primary'}" data-action="box-status" data-id="${Number(box.id)}" data-status="${Number(box.status) === 1 ? 0 : 1}">${Number(box.status) === 1 ? '下架' : '上架'}</button><button class="button outline" data-action="box-add-prize" data-id="${Number(box.id)}">添加奖品</button></article>`).join('') : '<div class="empty-state">暂无盲盒。</div>'; }
    catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }
  $('#admin-box-refresh').addEventListener('click', loadAdminBoxes);
  $('#box-admin-form').addEventListener('submit', async event => {
    event.preventDefault(); const values = Object.fromEntries(new FormData(event.currentTarget).entries()); let prizes;
    try { prizes = JSON.parse(values.prizes); if (!Array.isArray(prizes) || !prizes.length) throw new Error(); }
    catch (_) { return notify('奖品配置必须是有效的 JSON 数组。', 'error'); }
    try { const id = await api('/api/admin/blind-boxes', { method: 'POST', body: JSON.stringify({ name: values.name, albumId: Number(values.albumId), price: Number(values.price), totalCount: Number(values.totalCount), description: values.description || null, prizes }) }); notify(`盲盒已创建，编号 ${id}`); event.currentTarget.reset(); loadAdminBoxes(); }
    catch (error) { notify(error.message, 'error'); }
  });

  async function addPrize(boxId) {
    const prizeName = window.prompt('奖品名称'); if (!prizeName) return;
    const probability = Number(window.prompt('中奖概率（按后端配置填写）', '1'));
    if (!Number.isFinite(probability) || probability <= 0) return notify('概率必须大于 0。', 'error');
    const prizeLevel = Number(window.prompt('奖品稀有度等级', '1'));
    try { await api(`/api/admin/blind-boxes/${boxId}/prizes`, { method: 'POST', body: JSON.stringify({ prizeName, probability, prizeLevel, imageUrl: null, description: null }) }); notify('奖品配置已添加。'); loadAdminBoxes(); }
    catch (error) { notify(error.message, 'error'); }
  }

  async function loadAdminUsers() {
    const target = $('#admin-user-list'); target.innerHTML = '<div class="loading-card">正在加载…</div>';
    const params = new URLSearchParams({ current: '1', size: '50' }); const keyword = $('#user-keyword').value.trim(); if (keyword) params.set('keyword', keyword);
    try { const data = await api(`/api/admin/users?${params}`); const users = pageRecords(data); target.innerHTML = users.length ? users.map(user => `<article class="list-card row"><div class="admin-record-main"><h3>${escapeHtml(user.nickname || user.username)} <span class="status-pill">${escapeHtml(user.role || 'user')}</span></h3><p>用户 #${Number(user.id)} · ${escapeHtml(user.phone || '未填写手机号')} · ${Number(user.status) === 1 ? '正常' : '已禁用'}</p></div><button class="button outline" data-action="user-status" data-id="${Number(user.id)}" data-status="${Number(user.status) === 1 ? 0 : 1}">${Number(user.status) === 1 ? '禁用' : '启用'}</button><button class="button outline" data-action="user-role" data-id="${Number(user.id)}" data-role="${escapeHtml(user.role || 'user')}">调整角色</button></article>`).join('') : '<div class="empty-state">没有找到用户。</div>'; }
    catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }
  $('#admin-user-refresh').addEventListener('click', loadAdminUsers);

  $('#shipping-form').addEventListener('submit', async event => {
    event.preventDefault(); const values = Object.fromEntries(new FormData(event.currentTarget).entries()); const orderNo = values.orderNo; delete values.orderNo;
    if (!window.confirm(`确认登记订单 ${orderNo} 的发货信息？`)) return;
    try { await api(`/api/order/ship/${encodeURIComponent(orderNo)}`, { method: 'PUT', body: JSON.stringify(values) }); notify('发货信息已登记。'); event.currentTarget.reset(); }
    catch (error) { notify(error.message, 'error'); }
  });

  $('#media-form').addEventListener('submit', async event => {
    event.preventDefault(); const form = event.currentTarget; const file = form.elements.namedItem('file').files[0]; if (!file) return notify('请先选择文件。', 'error');
    const body = new FormData(); body.append('file', file);
    try { const data = await api(`/api/admin/media/${form.elements.namedItem('kind').value}`, { method: 'POST', body }); const url = data.url || data.path || ''; $('#media-result').innerHTML = `<p class="status-pill success">上传成功</p>${url ? `<p><a href="${escapeHtml(safeUrl(url))}" target="_blank" rel="noopener">${escapeHtml(url)}</a></p>` : `<pre>${escapeHtml(JSON.stringify(data, null, 2))}</pre>`}`; notify('媒体文件上传成功。'); }
    catch (error) { notify(error.message, 'error'); }
  });

  async function loadAudit() {
    const target = $('#admin-audit-list'); target.innerHTML = '<div class="loading-card">正在加载…</div>';
    try { const data = await api('/api/admin/audit-logs?current=1&size=50'); const records = pageRecords(data); target.innerHTML = records.length ? records.map(record => `<article class="list-card"><div class="row"><h3>${escapeHtml(record.httpMethod)} ${escapeHtml(record.requestPath)}</h3><span class="status-pill">HTTP ${Number(record.responseStatus)}</span></div><p>操作人 #${Number(record.operatorUserId)} · ${escapeHtml(record.operatorRole)} · ${escapeHtml(record.clientIp || '')}</p><p>${escapeHtml(record.createdAt || '')}</p></article>`).join('') : '<div class="empty-state">暂无审计记录。</div>'; }
    catch (error) { target.innerHTML = `<div class="empty-state">${escapeHtml(error.message)}</div>`; }
  }

  $$('.admin-tab').forEach(button => button.addEventListener('click', () => {
    $$('.admin-tab').forEach(tab => tab.classList.toggle('active', tab === button));
    $$('.admin-panel').forEach(panel => panel.classList.toggle('active', panel.id === `admin-${button.dataset.admin}`));
    const loaders = { albums: loadAdminAlbums, songs: () => {}, boxes: loadAdminBoxes, users: loadAdminUsers, shipping: () => {}, media: () => {}, audit: loadAudit };
    loaders[button.dataset.admin]?.();
  }));
  $('#admin-audit-refresh').addEventListener('click', loadAudit);
  $('#refresh-pending').addEventListener('click', loadPendingRefunds);
  $('#refresh-draws').addEventListener('click', loadBlindboxes);
  $('#profile-refresh').addEventListener('click', loadProfile);

  document.addEventListener('click', async event => {
    const action = event.target.closest('[data-action]'); if (!action) return;
    try {
      switch (action.dataset.action) {
        case 'detail': await showAlbum(id); break;
        case 'buy': { const album = state.albums.find(item => Number(item.id) === id) || await api(`/api/album/${id}`); await openCheckout(album); break; }
        case 'cart-add': await api('/api/cart/add', { method: 'POST', body: JSON.stringify({ albumId: id, quantity: 1 }) }); await loadCartCount(); notify('已加入购物车。'); break;
        case 'cart-checkout': { const album = await api(`/api/album/${Number(action.dataset.album)}`); await openCheckout(album); break; }
        case 'cart-toggle': await api(`/api/cart/toggleSelect/${id}?isSelected=${action.checked ? 1 : 0}`, { method: 'PUT' }); await loadCart(); break;
        case 'cart-select-all': await api(`/api/cart/toggleSelectAll?isSelected=${action.textContent.includes('取消') ? 0 : 1}`, { method: 'PUT' }); await loadCart(); break;
        case 'cart-minus': await api(`/api/cart/updateQuantity/${id}?quantity=${Math.max(1, Number(action.dataset.quantity) - 1)}`, { method: 'PUT' }); await loadCart(); break;
        case 'cart-plus': await api(`/api/cart/updateQuantity/${id}?quantity=${Number(action.dataset.quantity) + 1}`, { method: 'PUT' }); await loadCart(); break;
        case 'cart-remove': if (confirm('从购物车移除此商品？')) await mutateCart(`/api/cart/remove/${id}`); break;
        case 'cart-clear': if (confirm('确定清空购物车？')) await mutateCart('/api/cart/clear'); break;
        case 'cart-clear-invalid': await mutateCart('/api/cart/clearInvalid'); break;
        case 'address-default': await api(`/api/address/setDefault/${id}`, { method: 'PUT' }); await loadAddresses(); notify('默认地址已更新。'); break;
        case 'address-delete': if (confirm('确定删除这个地址？')) { await api(`/api/address/delete/${id}`, { method: 'DELETE' }); await loadAddresses(); notify('地址已删除。'); } break;
        case 'address-edit': {
          const address = state.addresses.find(item => Number(item.id) === id); if (!address) break;
          const form = $('#address-form'); form.dataset.addressId = id;
          for (const key of ['receiverName', 'receiverPhone', 'province', 'city', 'district', 'detailAddress', 'isDefault']) form.elements.namedItem(key).value = address[key] ?? '';
          form.querySelector('h2')?.replaceChildren(document.createTextNode('编辑收货地址')); form.scrollIntoView({ behavior: 'smooth' }); break;
        }
        case 'order-detail': { const data = await api(`/api/order/${encodeURIComponent(action.dataset.order)}`); alert(`订单：${data.orderNo}\n商品：${data.albumTitle}\n状态：${data.statusText}\n数量：${data.quantity}\n金额：¥${money(data.totalAmount)}\n收货信息：${data.receiverName || '数字内容订单'} ${data.receiverPhone || ''}\n${data.receiverAddress || ''}\n物流：${data.carrier || '暂无'} ${data.trackingNo || ''}`); break; }
        case 'order-pay': await startPayment(id, action.dataset.order); break;
        case 'order-cancel': if (confirm('确认取消该未支付订单？')) { await api(`/api/order/cancel/${encodeURIComponent(action.dataset.order)}`, { method: 'POST' }); await loadOrders(); notify('订单已取消。'); } break;
        case 'order-receive': if (confirm('确认已经收到商品？')) { await api(`/api/order/confirmReceipt/${encodeURIComponent(action.dataset.order)}`, { method: 'POST' }); await loadOrders(); notify('已确认收货。'); } break;
        case 'digital-content': { const url = await api(`/api/order/${encodeURIComponent(action.dataset.order)}/digital-content`); $('#payment-content').innerHTML = `<p class="eyebrow">DIGITAL DELIVERY</p><h2>已授权的数字内容</h2><p>仅向当前登录账号展示。请勿分享此链接。</p><code class="url-code">${escapeHtml(url)}</code>${safeUrl(url) ? `<p><a class="button primary" href="${escapeHtml(safeUrl(url))}" target="_blank" rel="noopener">打开内容</a></p>` : ''}`; $('#payment-dialog').showModal(); break; }
        case 'refund-apply': await applyRefund(id); break;
        case 'refund-review': { const approved = action.dataset.approved === 'true'; const auditRemark = prompt(approved ? '填写审核备注（选填）' : '请填写拒绝原因'); if (!approved && !auditRemark?.trim()) break; await api(`/api/refund/admin/${id}/review`, { method: 'PUT', body: JSON.stringify({ approved, auditRemark: auditRemark || '' }) }); notify('退款申请已审核。'); loadPendingRefunds(); break; }
        case 'payment-query': { const result = await api(`/api/payment/query/${encodeURIComponent(action.dataset.payment)}`); const labels = { 0: '待支付', 1: '支付成功', 2: '已取消/失败' }; notify(`支付状态：${labels[result.status] || result.status}`); if (Number(result.status) === 1) { $('#payment-dialog').close(); loadOrders(); } break; }
        case 'payment-cancel': if (confirm('确定取消该支付？')) { await api(`/api/payment/cancel/${encodeURIComponent(action.dataset.payment)}`, { method: 'POST' }); notify('支付已取消。'); $('#payment-dialog').close(); loadOrders(); } break;
        case 'album-edit': await editAlbum(id); break;
        case 'album-status': await api(`/api/admin/albums/${id}/status?status=${Number(action.dataset.status)}`, { method: 'PUT' }); notify('专辑状态已更新。'); loadAdminAlbums(); break;
        case 'song-edit': await editSong(id, Number(action.dataset.album)); break;
        case 'box-status': await api(`/api/admin/blind-boxes/${id}/status?status=${Number(action.dataset.status)}`, { method: 'PUT' }); notify('盲盒状态已更新。'); loadAdminBoxes(); break;
        case 'box-add-prize': await addPrize(id); break;
        case 'user-status': await api(`/api/admin/users/${id}/status`, { method: 'PUT', body: JSON.stringify({ status: Number(action.dataset.status) }) }); notify('用户状态已更新。'); loadAdminUsers(); break;
        case 'user-role': { const role = prompt('请输入角色：user、admin 或 super_admin', action.dataset.role); if (!role) break; if (!['user', 'admin', 'super_admin'].includes(role)) return notify('角色值无效。', 'error'); await api(`/api/admin/users/${id}/role`, { method: 'PUT', body: JSON.stringify({ role }) }); notify('用户角色已更新。'); loadAdminUsers(); break; }
        case 'box-detail': { const box = await api(`/api/blind-box/${id}`); $('#detail-content').innerHTML = `<p class="eyebrow">MYSTERY BOX</p><h2>${escapeHtml(box.blindBox?.name || '盲盒详情')}</h2><p>${escapeHtml(box.blindBox?.description || '')}</p><p>单抽 ¥${escapeHtml(box.blindBox?.price || '')} · 剩余 ${Number(box.blindBox?.remainCount || 0)}</p><h3>奖品信息</h3>${listFrom(box.prizes).map(prize => `<div class="track-row"><span>${escapeHtml(prize.prizeName)}</span><span>${escapeHtml(prize.probability)}%</span></div>`).join('') || '<p>暂无奖品配置。</p>'}<div class="notice-card"><span>i</span><p>抽取接口暂未开放，当前不能购买或抽取盲盒。</p></div>`; $('#detail-dialog').showModal(); break; }
        default: break;
      }
    } catch (error) { notify(error.message, 'error'); }
  });

  document.addEventListener('change', event => {
    if (event.target.name === 'productType') $('.digital-field').classList.toggle('hidden', event.target.value !== 'DIGITAL');
  });

  document.addEventListener('play', event => {
    const player = event.target.closest('audio[data-song-id]');
    if (!player) return;
    const status = player.closest('.track-row')?.querySelector('[data-audio-status]');
    if (status) status.textContent = '正在加载试听音频…';
  }, true);

  document.addEventListener('playing', event => {
    const player = event.target.closest('audio[data-song-id]');
    if (!player) return;
    const status = player.closest('.track-row')?.querySelector('[data-audio-status]');
    if (status) status.textContent = '正在播放';
    if (player && state.token && !player.dataset.counted) {
      player.dataset.counted = '1';
      api(`/api/album/song/${Number(player.dataset.songId)}/play`, { method: 'POST' }).catch(() => {});
    }
  }, true);

  document.addEventListener('pause', event => {
    const player = event.target.closest('audio[data-song-id]');
    if (!player || player.ended) return;
    const status = player.closest('.track-row')?.querySelector('[data-audio-status]');
    if (status) status.textContent = '已暂停';
  }, true);

  document.addEventListener('error', event => {
    const player = event.target.closest?.('audio[data-song-id]');
    if (!player) return;
    const status = player.closest('.track-row')?.querySelector('[data-audio-status]');
    if (status) status.textContent = '试听音频加载失败：请检查地址或文件是否存在。';
  }, true);

  $('#health-check').addEventListener('click', async () => {
    try { const data = await api('/api/test/hello'); notify(data.message || '服务响应正常。'); }
    catch (error) { notify(error.message, 'error'); }
  });

  if (state.token && !state.user) {
    api('/api/user/info').then(user => { state.user = user; sessionStorage.setItem(USER_KEY, JSON.stringify(user)); renderSession(); }).catch(() => {});
  }
  renderSession();
  const hashPage = location.hash.replace(/^#/, '');
  if (state.token && hashPage && $(`#page-${CSS.escape(hashPage)}`)) openPage(hashPage);
})();
