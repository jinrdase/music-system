import { test, expect } from '@playwright/test'

test('QA 用户注册、浏览、加购、下单、模拟支付和申请退款', async ({ page }) => {
  const pageErrors = []
  const failedApiRequests = []
  const badApiResponses = []
  const cartResponses = []
  page.on('pageerror', error => pageErrors.push(error.message))
  page.on('response', async response => {
    if (!response.url().includes('/api/')) return
    let body
    try { body = await response.json() } catch { /* non-JSON callback/asset */ }
    if (response.url().includes('/api/cart/'))
      cartResponses.push({ url: response.url(), status: response.status(), code: body?.code })
    if (response.status() >= 400 || (body && 'code' in body && Number(body.code) !== 200))
      badApiResponses.push({ url: response.url(), status: response.status(), code: body?.code })
  })
  page.on('requestfailed', request => {
    if (request.url().includes('/api/')) failedApiRequests.push(`${request.method()} ${request.url()}`)
  })

  const suffix = `${Date.now()}`.slice(-10)
  const username = `e2eqa${suffix}`
  const password = 'E2eTest!2026'

  await page.goto('/login')
  await page.evaluate(() => { sessionStorage.clear(); localStorage.clear() })
  await page.getByRole('link', { name: '创建账号' }).click()
  const registerUsername = page.getByLabel('用户名')
  await registerUsername.fill(username)
  await expect(registerUsername).toHaveValue(username)
  await page.locator('input[autocomplete="new-password"]').nth(0).fill(password)
  await page.locator('input[autocomplete="new-password"]').nth(1).fill(password)
  await page.getByRole('button', { name: '注册' }).click()
  await expect(page).toHaveURL(/\/login\?username=/)
  await page.locator('input[autocomplete="username"]').fill(username)
  await page.locator('input[autocomplete="current-password"]').fill(password)
  await page.getByRole('button', { name: '登录' }).click()
  await expect(page).toHaveURL('/')
  await expect(page.getByRole('link', { name: username })).toBeVisible()
  await expect(page.locator('.album-card').first()).toBeVisible()

  await page.locator('.album-card a').first().click()
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible()
  await page.getByRole('button', { name: '加入购物车' }).click()
  await expect(page.getByText('已加入购物车')).toBeVisible()
  await page.getByRole('link', { name: '购物袋' }).click()
  await expect(page.getByRole('button', { name: '单件结算' }).first(), JSON.stringify(cartResponses)).toBeVisible()

  await page.goto('/addresses')
  await page.getByRole('button', { name: '新增地址' }).click()
  const values = [
    ['收件人', 'E2E 测试用户'], ['手机号', '13800001234'], ['省份', '浙江省'],
    ['城市', '杭州市'], ['区县', '西湖区'], ['详细地址', '自动化测试路 1 号'],
  ]
  for (const [label, value] of values) await page.getByLabel(label).fill(value)
  await page.getByText('设为默认地址').click()
  await page.getByRole('button', { name: '保存' }).click()
  await expect(page.getByText('E2E 测试用户')).toBeVisible()

  await page.goto('/cart')
  await page.getByRole('button', { name: '单件结算' }).first().click()
  await page.getByRole('button', { name: 'OK' }).click()
  await expect(page).toHaveURL(/\/orders$/)
  await expect(page.getByRole('heading', { name: '我的订单' })).toBeVisible()
  await page.getByRole('button', { name: '支付' }).first().click()
  await expect(page.getByText(/模拟支付完成/)).toBeVisible()
  await expect(page.getByText('已支付').first()).toBeVisible()

  await page.getByRole('button', { name: '详情' }).first().click()
  await page.getByRole('button', { name: '申请退款' }).click()
  await page.getByPlaceholder('简要说明退款原因').fill('E2E 自动化验收退款申请')
  await page.getByRole('button', { name: '提交申请' }).click()
  await expect(page.getByText('退款申请已提交')).toBeVisible()
  await page.goto('/blindboxes')
  await expect(page.getByRole('button', { name: '查看详情' }).first()).toBeVisible()
  await page.getByRole('button', { name: '查看详情' }).first().click()
  await expect(page.getByRole('dialog')).toBeVisible()
  await expect(page.getByText(/支付成功后由后端自动抽取/)).toBeVisible()
  await page.getByRole('button', { name: '创建待支付订单' }).click()
  await expect(page).toHaveURL(/\/orders\//)
  await page.getByRole('button', { name: '立即支付' }).click()
  await expect(page.getByText(/模拟支付完成/)).toBeVisible()
  await expect(page.getByText('已支付')).toBeVisible()
  await page.goto('/blindboxes')
  await expect(page.getByRole('heading', { name: '我的抽取记录' })).toBeVisible()
  await expect(page.locator('.el-table__body-wrapper tbody tr').first()).toBeVisible()
  await expect(page.locator('.el-table__body-wrapper tbody tr').first().locator('img.prize-thumbnail')).toBeVisible()
  await expect.poll(() => page.locator('.el-table__body-wrapper tbody tr').first().locator('img.prize-thumbnail').evaluate(img => img.complete && img.naturalWidth > 0)).toBe(true)
  await page.goto('/admin/audit-logs')
  await expect(page).toHaveURL('/')

  expect(pageErrors).toEqual([])
  expect(failedApiRequests).toEqual([])
  expect(badApiResponses).toEqual([])
})

test('未登录时受保护页面回到登录页，普通用户不能进入后台', async ({ page }) => {
  await page.goto('/orders')
  await expect(page).toHaveURL(/\/login\?redirect=/)
  await page.goto('/admin/audit-logs')
  await expect(page).toHaveURL(/\/login\?redirect=/)
})

test('管理员后台及审计日志页面', async ({ page }) => {
  test.skip(!process.env.E2E_ADMIN_USERNAME || !process.env.E2E_ADMIN_PASSWORD,
    '需要经批准建立的本地 QA 管理员账号，凭据通过环境变量提供。')
  await page.goto('/login')
  await page.locator('input[autocomplete="username"]').fill(process.env.E2E_ADMIN_USERNAME)
  await page.locator('input[autocomplete="current-password"]').fill(process.env.E2E_ADMIN_PASSWORD)
  await page.getByRole('button', { name: '登录' }).click()
  await expect(page.getByRole('link', { name: '管理后台' })).toBeVisible()
  const pageErrors = []
  const failedApis = []
  page.on('pageerror', error => pageErrors.push(error.message))
  page.on('requestfailed', request => {
    if (request.url().includes('/api/')) failedApis.push(request.url())
  })
  for (const path of ['/', '/albums/1', '/blindboxes', '/cart', '/addresses', '/orders', '/profile', '/refunds']) {
    await page.goto(path)
    await expect(page.locator('.site-shell .main-content')).toBeVisible()
    await expect(page.locator('.site-shell .main-content')).not.toBeEmpty()
  }
  await page.goto('/blindboxes')
  if (await page.getByRole('button', { name: '查看详情' }).count()) {
    await page.getByRole('button', { name: '查看详情' }).first().click()
    await expect(page.getByRole('dialog')).toBeVisible()
    await page.keyboard.press('Escape')
    await expect(page.getByRole('dialog')).toBeHidden()
  }
  for (const path of ['/admin', '/admin/albums', '/admin/songs', '/admin/blindboxes',
    '/admin/users', '/admin/orders', '/admin/audit-logs']) {
    await page.goto(path)
    await expect(page.locator('.admin-main')).toBeVisible()
    await expect(page.locator('.admin-main')).not.toBeEmpty()
  }
  await expect(page.getByRole('heading', { name: '操作审计' })).toBeVisible()
  await page.setViewportSize({ width: 390, height: 844 })
  for (const path of ['/admin', '/admin/albums', '/admin/songs', '/admin/blindboxes',
    '/admin/users', '/admin/orders', '/admin/audit-logs']) {
    await page.goto(path)
    await expect(page.locator('.admin-main')).toBeVisible()
    const overflow = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth)
    expect(overflow, `移动端页面横向溢出: ${path}`).toBe(false)
  }
  expect(pageErrors).toEqual([])
  expect(failedApis).toEqual([])
})

test('移动端登录和首页布局无横向溢出', async ({ page }) => {
  test.skip(!process.env.E2E_ADMIN_USERNAME || !process.env.E2E_ADMIN_PASSWORD,
    '移动端首页检查使用本地 QA 管理员账号。')
  await page.setViewportSize({ width: 390, height: 844 })
  await page.goto('/login')
  await expect(page.getByRole('button', { name: '登录' })).toBeVisible()
  const loginOverflow = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth)
  expect(loginOverflow).toBe(false)
  await page.locator('input[autocomplete="username"]').fill(process.env.E2E_ADMIN_USERNAME)
  await page.locator('input[autocomplete="current-password"]').fill(process.env.E2E_ADMIN_PASSWORD)
  await page.getByRole('button', { name: '登录' }).click()
  await expect(page).toHaveURL('/')
  await page.goto('/')
  await expect(page.locator('.album-grid').first()).toBeVisible()
  const homeOverflow = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth)
  expect(homeOverflow).toBe(false)
})

test('无效Token和退出登录会清除登录状态', async ({ page }) => {
  test.skip(!process.env.E2E_ADMIN_USERNAME || !process.env.E2E_ADMIN_PASSWORD,
    '退出登录检查使用本地 QA 管理员账号。')
  await page.goto('/login')
  await page.evaluate(() => sessionStorage.setItem('music-token', 'expired.invalid.token'))
  await page.goto('/profile')
  await expect(page).toHaveURL(/\/login\?redirect=/)
  await expect.poll(() => page.evaluate(() => sessionStorage.getItem('music-token'))).toBeNull()
  await page.locator('input[autocomplete="username"]').fill(process.env.E2E_ADMIN_USERNAME)
  await page.locator('input[autocomplete="current-password"]').fill(process.env.E2E_ADMIN_PASSWORD)
  await page.getByRole('button', { name: '登录' }).click()
  await expect(page).toHaveURL('/profile')
  await page.getByRole('button', { name: '退出' }).click()
  await expect(page).toHaveURL('/login')
  await expect.poll(() => page.evaluate(() => sessionStorage.getItem('music-token'))).toBeNull()
})
