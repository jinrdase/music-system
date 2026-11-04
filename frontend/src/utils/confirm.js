import { ElMessageBox } from 'element-plus'

/**
 * 全站统一确认弹窗：深色卡片皮肤（.app-confirm，见 global.css）、
 * 明确的主/次按钮文案与 loading 语义。替代散落各页的裸 ElMessageBox.confirm。
 * 返回 Promise：确认 resolve、取消 reject（调用方用 await 时让上层 catch/忽略即可，
 * 本工具默认把 cancel 转为静默 resolve(false)，避免未捕获 rejection）。
 */
export function confirmAction(message, { title = '请确认', confirmText = '确定', cancelText = '再想想', type = 'warning' } = {}) {
  return ElMessageBox.confirm(message, title, {
    confirmButtonText: confirmText,
    cancelButtonText: cancelText,
    type,
    customClass: 'app-confirm',
    autofocus: false,
  }).then(
    () => true,
    () => false,
  )
}
