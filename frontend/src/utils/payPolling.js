import { queryPayment } from '../api/order'

/**
 * 支付结果轮询（驱动后端查单补偿）：
 * 开发环境收不到支付宝异步回调（notify_url 需公网），真实沙箱支付的状态推进
 * 依赖前端轮询 GET /api/payment/query/{paymentNo}——后端在轮询中主动向支付宝查单，
 * 已支付则推进支付单与订单（见接口文档 §8.2）。
 *
 * status=1 已支付 → onPaid 后停止；status=2 已关闭 → onClosed 后停止；
 * 其余每 interval 查一次，超过 expireTime（后端毫秒时间戳）+30s 缓冲仍未确认 → onFinish 后停止。
 * 单次查询失败静默继续（网络抖动/后端重启不中断轮询）。
 * 返回 stop()，组件卸载或重新发起支付时务必调用，避免重复轮询。
 */
export function startPayPolling(paymentNo, { expireTime, interval = 2500, onPaid, onClosed, onFinish } = {}) {
  if (!paymentNo) return () => {}
  const deadline = Number(expireTime) > 0 ? Number(expireTime) + 30 * 1000 : Date.now() + 16 * 60 * 1000
  let timer = null
  let stopped = false
  async function tick() {
    if (stopped) return
    try {
      const payment = await queryPayment(paymentNo)
      const status = Number(payment && payment.status)
      if (status === 1) { stop(); if (onPaid) onPaid(payment); return }
      if (status === 2) { stop(); if (onClosed) onClosed(payment); return }
    } catch (e) { /* 单次查询失败不中断轮询 */ }
    if (stopped) return
    if (Date.now() > deadline) { stop(); if (onFinish) onFinish(); return }
    timer = setTimeout(tick, interval)
  }
  function stop() { stopped = true; if (timer) { clearTimeout(timer); timer = null } }
  timer = setTimeout(tick, interval)
  return stop
}
