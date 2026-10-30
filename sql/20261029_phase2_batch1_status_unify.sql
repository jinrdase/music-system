-- 二期第一批（F-4.9 订单状态口径统一）
-- 统一 order_info.status 注释口径为代码唯一事实来源：
--   0-待支付，1-已支付，2-已完成，3-已取消，4-已发货，5-已退款
-- 仅修改列注释，不影响数据与索引。
ALTER TABLE `order_info`
    MODIFY COLUMN `status` tinyint NOT NULL DEFAULT 0
    COMMENT '订单状态：0-待支付，1-已支付，2-已完成，3-已取消，4-已发货，5-已退款';

-- 存量数据核对（人工执行，确认无 0~5 之外的脏值）：
-- SELECT status, COUNT(*) FROM order_info GROUP BY status;
