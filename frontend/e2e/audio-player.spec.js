import { test, expect } from '@playwright/test'

async function loginExistingQaUser(page) {
  test.skip(!process.env.E2E_TEST_USERNAME || !process.env.E2E_TEST_PASSWORD,
    '需要使用现有本地 QA 用户凭据；本测试不会注册或修改账号。')
  await page.goto('/login')
  await page.locator('input[autocomplete="username"]').fill(process.env.E2E_TEST_USERNAME)
  await page.locator('input[autocomplete="current-password"]').fill(process.env.E2E_TEST_PASSWORD)
  await page.getByRole('button', { name: '登录' }).click()
  await expect(page).toHaveURL('/')
}

test('歌曲播放点击给出真实音频状态，切歌与音量控件有反馈，不伪报播放成功', async ({ page }) => {
  const pageErrors = []
  const failedApiRequests = []
  const playCountRequests = []
  const mediaRequests = []
  page.on('pageerror', error => pageErrors.push(error.message))
  page.on('requestfailed', request => {
    if (request.url().includes('/api/')) failedApiRequests.push(`${request.method()} ${request.url()}`)
  })
  page.on('request', request => {
    if (request.url().includes('/api/album/song/') && request.url().endsWith('/play')) playCountRequests.push(request.url())
    if (request.resourceType() === 'media') mediaRequests.push(request.url())
  })

  await loginExistingQaUser(page)
  await page.goto('/albums/1')
  const tracks = page.locator('.track-row')
  await expect(tracks).toHaveCount(3)
  await tracks.nth(0).getByRole('button').click()

  const player = page.getByTestId('global-audio-player')
  const audio = player.locator('audio')
  await expect(player).toBeVisible()
  await expect(player).toHaveAttribute('data-player-status', 'unavailable')
  await expect(player.getByRole('status')).toContainText('example.com 示例地址')
  await expect(audio).not.toHaveAttribute('src', /.+/)
  expect(await audio.evaluate(element => element.currentSrc)).toBe('')
  expect(playCountRequests).toHaveLength(0)
  expect(mediaRequests).toHaveLength(0)

  const firstTrackTitle = (await tracks.nth(0).locator('b').innerText()).replace(/^\d+\.\s*/, '')
  const secondTrackTitle = (await tracks.nth(1).locator('b').innerText()).replace(/^\d+\.\s*/, '')
  await player.getByRole('button', { name: '下一首' }).click()
  await expect(player).toHaveAttribute('data-player-status', 'unavailable')
  await expect(player.locator('.player-track strong')).toHaveText(secondTrackTitle)
  await player.getByRole('button', { name: '上一首' }).click()
  await expect(player.locator('.player-track strong')).toHaveText(firstTrackTitle)

  const volume = player.getByRole('slider', { name: '音量' })
  await volume.evaluate(element => {
    element.value = '0.35'
    element.dispatchEvent(new Event('input', { bubbles: true }))
  })
  await expect.poll(() => audio.evaluate(element => element.volume)).toBeCloseTo(0.35)

  await page.goto('/albums/5')
  const noPreviewTrack = page.locator('.track-row').first()
  await expect(noPreviewTrack).toBeVisible()
  await expect(noPreviewTrack).toContainText('暂无试听音频')
  await noPreviewTrack.getByRole('button').click()
  await expect(player).toHaveAttribute('data-player-status', 'unavailable')
  await expect(player.getByRole('status')).toContainText('没有配置试听音频')
  expect(await audio.evaluate(element => element.currentSrc)).toBe('')
  expect(pageErrors).toEqual([])
  expect(failedApiRequests).toEqual([])
})
