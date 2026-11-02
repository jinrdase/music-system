import { test, expect } from '@playwright/test'

const albumImages = Array.from({ length: 14 }, (_, index) =>
  `/media/image/album-${String(index + 1).padStart(2, '0')}-${[
    'night-voyage', 'chasing-light', 'city-echoes', 'qa-jazz-vinyl', 'qa-rock-stage',
    'qa-neon-gradient', 'qa-classical-piano', 'qa-red-vinyl', 'qa-rock-lights',
    'qa-geometric-electronic', 'qa-vinyl-classic', 'qa-guitar-energy', 'qa-galaxy-forest', 'qa-neon-art',
  ][index]}.jpg`)

const blindboxImages = [
  'blindbox-01-classic-figurine.jpg',
  'blindbox-02-qa-garden-figure.jpg',
  'blindbox-03-qa-heart-teddy.jpg',
  'blindbox-04-qa-pink-gift-bear.jpg',
  'blindbox-05-qa-figurine-shelf.jpg',
  'blindbox-06-qa-art-figurine.jpg',
].map(name => `/media/image/${name}`)

async function imageLoaded(locator) {
  await expect(locator).toBeVisible()
  await expect.poll(() => locator.evaluate(image => image.complete && image.naturalWidth > 0)).toBe(true)
}

async function loginAdmin(page) {
  test.skip(!process.env.E2E_ADMIN_USERNAME || !process.env.E2E_ADMIN_PASSWORD,
    '需要通过临时环境变量提供本地 QA 管理员凭据。')
  await page.goto('/login')
  await page.locator('input[autocomplete="username"]').fill(process.env.E2E_ADMIN_USERNAME)
  await page.locator('input[autocomplete="current-password"]').fill(process.env.E2E_ADMIN_PASSWORD)
  await page.getByRole('button', { name: '登录' }).click()
  await expect(page).toHaveURL('/')
}

async function loginQaUser(page) {
  test.skip(!process.env.E2E_TEST_USERNAME || !process.env.E2E_TEST_PASSWORD,
    '需要通过临时环境变量提供现有的本地 QA 用户凭据。')
  await page.goto('/login')
  await page.locator('input[autocomplete="username"]').fill(process.env.E2E_TEST_USERNAME)
  await page.locator('input[autocomplete="current-password"]').fill(process.env.E2E_TEST_PASSWORD)
  await page.getByRole('button', { name: '登录' }).click()
  await expect(page).toHaveURL('/')
}

test('首页、专辑详情、盲盒列表和盲盒详情加载真实商品图片', async ({ page }) => {
  const errors = []
  page.on('pageerror', error => errors.push(error.message))

  for (const path of [...albumImages, ...blindboxImages]) {
    const response = await page.request.get(`http://localhost:8080${path}`)
    expect(response.status(), path).toBe(200)
    expect(response.headers()['content-type'], path).toContain('image/jpeg')
  }

  await loginQaUser(page)
  const albumCards = page.locator('.album-card')
  await expect(albumCards).toHaveCount(3)
  for (const image of await albumCards.locator('img').all()) await imageLoaded(image)
  await albumCards.first().locator('.album-title').click()
  const detailCover = page.locator('.detail-cover')
  await imageLoaded(detailCover)

  await page.goto('/blindboxes')
  const boxCards = page.locator('.blindbox-card')
  await expect(boxCards).toHaveCount(1)
  await imageLoaded(boxCards.locator('.blindbox-cover'))
  await boxCards.getByRole('button', { name: '查看详情' }).click()
  await imageLoaded(page.locator('.blindbox-detail-cover'))
  const prizeImages = page.locator('.el-dialog .prize-thumbnail')
  await expect(prizeImages).toHaveCount(8)
  for (const image of await prizeImages.all()) await imageLoaded(image)
  expect(errors).toEqual([])
})

test('QA 管理端专辑、全部盲盒及抽取记录表格显示数据库关联图片', async ({ page }) => {
  await loginAdmin(page)

  await page.goto('/admin/albums')
  const firstPageCovers = page.locator('.el-table__body-wrapper tbody img')
  await expect(firstPageCovers).toHaveCount(10)
  for (const image of await firstPageCovers.all()) await imageLoaded(image)
  await page.locator('.el-pagination .btn-next').click()
  const secondPageCovers = page.locator('.el-table__body-wrapper tbody img')
  await expect(secondPageCovers).toHaveCount(4)
  for (const image of await secondPageCovers.all()) await imageLoaded(image)

  await page.goto('/admin/blindboxes')
  const blindboxCovers = page.locator('.el-table__body-wrapper tbody img')
  await expect(blindboxCovers).toHaveCount(6)
  for (const image of await blindboxCovers.all()) await imageLoaded(image)
})
