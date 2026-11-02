import { test, expect } from '@playwright/test'

async function loginAdmin(page) {
  test.skip(!process.env.E2E_ADMIN_USERNAME || !process.env.E2E_ADMIN_PASSWORD,
    '需要通过临时环境变量提供本地 QA 管理员凭据。')
  await page.goto('/login')
  await page.locator('input[autocomplete="username"]').fill(process.env.E2E_ADMIN_USERNAME)
  await page.locator('input[autocomplete="current-password"]').fill(process.env.E2E_ADMIN_PASSWORD)
  await page.getByRole('button', { name: '登录' }).click()
  await expect(page).toHaveURL('/')
}

test('管理员新增和编辑 QA 专辑、歌曲并验证关联与列表刷新', async ({ page }) => {
  const writes = []
  page.on('request', request => {
    if (request.url().includes('/api/admin/') && ['POST', 'PUT'].includes(request.method()))
      writes.push(`${request.method()} ${new URL(request.url()).pathname}`)
  })
  await loginAdmin(page)
  const suffix = Date.now().toString()
  const albumTitle = `QA验收专辑-${suffix}`
  await page.goto('/admin/albums')
  await page.getByRole('button', { name: '新增专辑' }).click()
  await page.getByRole('button', { name: '保存' }).click()
  await expect(page.getByText('请输入专辑名称')).toBeVisible()
  await page.getByLabel('专辑名称').fill(albumTitle)
  await page.getByLabel('艺人').fill('QA 自动化测试艺人')
  await page.getByLabel('价格').fill('1.25')
  await page.getByLabel('库存').fill('5')
  const releaseDateInput = page.locator('.el-form-item').filter({ hasText: '发行日期' }).locator('input')
  await page.getByRole('button', { name: '保存' }).click()
  await expect(page.getByText('请选择发行日期')).toBeVisible()
  expect(writes.filter(value => value === 'POST /api/admin/albums')).toHaveLength(0)
  await releaseDateInput.fill('2026-11-02')
  await releaseDateInput.press('Enter')
  await page.locator('.el-form-item').filter({ hasText: '上架状态' }).locator('.el-select__wrapper').click()
  await page.getByRole('option', { name: '下架' }).click()
  const saveAlbumButton = page.getByRole('button', { name: '保存' })
  const albumCreateResponsePromise = page.waitForResponse(response =>
    response.url().includes('/api/admin/albums') && response.request().method() === 'POST')
  await saveAlbumButton.dblclick({ delay: 20 })
  const albumCreateResponse = await albumCreateResponsePromise
  const albumCreateBody = await albumCreateResponse.json()
  expect(albumCreateResponse.status(), JSON.stringify(albumCreateBody)).toBe(200)
  expect(Number(albumCreateBody.code), JSON.stringify(albumCreateBody)).toBe(200)
  await expect(page.getByText('专辑已保存')).toBeVisible()
  await page.getByPlaceholder('按专辑名称搜索').fill(albumTitle)
  await page.getByRole('button', { name: '搜索' }).click()
  const albumRow = page.locator('tr').filter({ hasText: albumTitle })
  await expect(albumRow).toBeVisible()
  const albumId = (await albumRow.locator('td').first().innerText()).trim()
  expect(Number(albumId)).toBeGreaterThan(0)
  await expect(albumRow).toContainText('下架')
  await albumRow.getByRole('button', { name: '编辑' }).click()
  const editedAlbumTitle = `${albumTitle}-已编辑`
  await page.getByLabel('专辑名称').fill(editedAlbumTitle)
  await page.getByLabel('简介').fill('QA 前端验收编辑后的描述')
  await page.getByRole('button', { name: '保存' }).click()
  await expect(page.getByText('专辑已保存')).toBeVisible()
  await page.getByPlaceholder('按专辑名称搜索').fill(editedAlbumTitle)
  await page.getByRole('button', { name: '搜索' }).click()
  await expect(page.locator('tr').filter({ hasText: editedAlbumTitle })).toBeVisible()

  await page.goto('/admin/songs')
  await page.getByPlaceholder('专辑 ID').fill(albumId)
  await page.getByRole('button', { name: '加载歌曲' }).click()
  await page.getByRole('button', { name: '新增歌曲' }).click()
  const songTitle = `QA验收歌曲-${suffix}`
  await page.getByLabel('标题').fill(songTitle)
  await page.getByLabel('艺人').fill('QA 自动化测试艺人')
  await page.getByLabel('曲序').fill('1')
  await page.getByRole('spinbutton', { name: '*时长秒' }).fill('90')
  await page.getByRole('button', { name: '保存' }).click()
  await expect(page.getByText('歌曲已保存')).toBeVisible()
  const songRow = page.locator('tr').filter({ hasText: songTitle })
  await expect(songRow).toBeVisible()
  await songRow.getByRole('button', { name: '编辑' }).click()
  const editedSongTitle = `${songTitle}-已编辑`
  await page.getByLabel('标题').fill(editedSongTitle)
  await page.getByRole('button', { name: '保存' }).click()
  await expect(page.getByText('歌曲已保存')).toBeVisible()
  await expect(page.locator('tr').filter({ hasText: editedSongTitle })).toBeVisible()
  expect(writes.some(value => value.startsWith('POST /api/admin/albums'))).toBe(true)
  expect(writes.some(value => value.startsWith('PUT /api/admin/albums/'))).toBe(true)
  expect(writes.some(value => value.startsWith('POST /api/admin/songs'))).toBe(true)
  expect(writes.some(value => value.startsWith('PUT /api/admin/songs/'))).toBe(true)
  expect(writes.filter(value => value === 'POST /api/admin/albums')).toHaveLength(1)
})

test('管理员创建下架 QA 盲盒并添加奖品；不假设后端存在盲盒编辑接口', async ({ page }) => {
  const writes = []
  page.on('request', request => {
    if (request.url().includes('/api/admin/') && ['POST', 'PUT'].includes(request.method()))
      writes.push(`${request.method()} ${new URL(request.url()).pathname}`)
  })
  await loginAdmin(page)
  const suffix = Date.now().toString()
  await page.goto('/admin/albums')
  await page.getByRole('button', { name: '新增专辑' }).click()
  await page.getByLabel('专辑名称').fill(`QA盲盒关联专辑-${suffix}`)
  await page.getByLabel('艺人').fill('QA 自动化测试艺人')
  await page.getByLabel('价格').fill('1.25')
  await page.getByLabel('库存').fill('3')
  const releaseDateInput = page.locator('.el-form-item').filter({ hasText: '发行日期' }).locator('input')
  await releaseDateInput.fill('2026-11-02')
  await releaseDateInput.press('Enter')
  await page.locator('.el-form-item').filter({ hasText: '上架状态' }).locator('.el-select__wrapper').click()
  await page.getByRole('option', { name: '下架' }).click()
  await page.getByRole('button', { name: '保存' }).click()
  await expect(page.getByText('专辑已保存')).toBeVisible()
  const albumRow = page.locator('tr').filter({ hasText: `QA盲盒关联专辑-${suffix}` })
  await expect(albumRow).toBeVisible()
  const albumId = (await albumRow.locator('td').first().innerText()).trim()

  await page.goto('/admin/blindboxes')
  await page.getByRole('button', { name: '新建盲盒' }).click()
  await page.locator('.el-dialog textarea').fill('[invalid-json')
  await page.getByRole('button', { name: '创建' }).click()
  await expect(page.getByText('奖品必须是有效且非空的 JSON 数组')).toBeVisible()
  const boxName = `QA验收盲盒-${suffix}`
  await page.getByLabel('盲盒名称').fill(boxName)
  await page.getByLabel('关联专辑 ID').fill(albumId)
  await page.getByLabel('价格').fill('1.25')
  await page.getByLabel('总库存').fill('2')
  await page.getByLabel(/奖品配置 JSON/).fill(JSON.stringify([
    { prizeName: `QA SSR-${suffix}`, prizeLevel: 1, probability: 20 },
    { prizeName: `QA SR-${suffix}`, prizeLevel: 2, probability: 80 },
  ]))
  await page.getByRole('button', { name: '创建' }).dblclick({ delay: 20 })
  await expect(page.getByText('盲盒已创建')).toBeVisible()
  const boxRow = page.locator('tr').filter({ hasText: boxName })
  await expect(boxRow).toBeVisible()
  await expect(boxRow).toContainText('下架')
  const boxId = (await boxRow.locator('td').first().innerText()).trim()
  expect(writes.filter(value => value === 'POST /api/admin/blind-boxes')).toHaveLength(1)
  await boxRow.getByRole('button', { name: '添加奖品' }).click()
  await page.getByLabel('奖品名称').fill(`QA 新增奖品-${suffix}`)
  await page.getByLabel('稀有度').fill('3')
  await page.getByLabel('概率').fill('1')
  await page.getByRole('button', { name: '添加', exact: true }).dblclick({ delay: 20 })
  await expect(page.getByText('奖品已添加')).toBeVisible()
  expect(writes.filter(value => value === `POST /api/admin/blind-boxes/${boxId}/prizes`)).toHaveLength(1)
  await boxRow.getByRole('button', { name: '上架' }).click()
  await expect(boxRow).toContainText('上架')
  await boxRow.getByRole('button', { name: '下架' }).click()
  await expect(boxRow).toContainText('下架')
  expect(writes.some(value => value.startsWith('POST /api/admin/blind-boxes'))).toBe(true)
  expect(writes.some(value => value.startsWith('POST /api/admin/blind-boxes/'))).toBe(true)
  expect(writes.some(value => value === `PUT /api/admin/blind-boxes/${boxId}/status`)).toBe(true)
})

test('管理员通过页面上传 QA PNG 并验证返回地址和实际图片响应', async ({ page }) => {
  test.skip(!process.env.E2E_ADMIN_USERNAME || !process.env.E2E_ADMIN_PASSWORD,
    '需要通过临时环境变量提供本地 QA 管理员凭据。')
  const mediaRequests = []
  const mediaResponses = []
  const pageErrors = []
  page.on('request', request => {
    if (request.url().includes('/api/admin/media/image')) mediaRequests.push({
      method: request.method(), url: request.url(), contentType: request.headers()['content-type'],
    })
  })
  page.on('response', async response => {
    if (!response.url().includes('/api/admin/media/image')) return
    let body = {}
    try { body = await response.json() } catch { /* record HTTP response if body is not JSON */ }
    mediaResponses.push({ status: response.status(), code: body.code, message: body.message })
  })
  page.on('pageerror', error => pageErrors.push(error.message))
  await loginAdmin(page)
  const suffix = Date.now().toString()
  const imageBytes = Buffer.from(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=',
    'base64',
  )
  await page.goto('/admin')
  const fileInput = page.locator('input[type="file"]').first()
  const upload = page.getByRole('button', { name: '上传' }).first()
  await upload.click()
  await expect(page.getByText('请先选择文件')).toBeVisible()
  await fileInput.setInputFiles({
    name: `qa-invalid-${suffix}.txt`, mimeType: 'text/plain', buffer: Buffer.from('QA invalid media test'),
  })
  await upload.click()
  await expect(page.getByText('文件类型不受支持')).toBeVisible()
  await fileInput.setInputFiles({
    name: `qa-frontend-acceptance-${suffix}.png`, mimeType: 'image/png', buffer: imageBytes,
  })
  await expect(upload).toHaveAttribute('data-file-selected', 'true')
  await upload.dblclick({ delay: 20 })
  await expect(page.getByText('文件已上传'), JSON.stringify({ mediaRequests, mediaResponses })).toBeVisible({ timeout: 30_000 })
  await expect.poll(() => mediaResponses.length).toBe(2)
  expect(mediaResponses.filter(result => result.code === 500 && result.message === '文件类型不受支持')).toHaveLength(1)
  expect(mediaResponses.filter(result => result.code === 200)).toHaveLength(1)
  expect(mediaRequests).toHaveLength(2)
  const imageUrl = await page.locator('input[readonly]').last().inputValue()
  expect(imageUrl).toMatch(/^\/media\/image\/[a-f0-9]+\.png$/)
  await expect.poll(() => page.locator('img.media-preview').evaluate(img => img.complete && img.naturalWidth > 0)).toBe(true)
  const imageResponse = await page.request.get(`http://localhost:8080${imageUrl}`)
  expect(imageResponse.status()).toBe(200)
  expect(imageResponse.headers()['content-type']).toContain('image/png')
  expect(pageErrors).toEqual([])
})
