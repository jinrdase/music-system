-- 抽取记录关联盲盒订单，便于支付后按订单查询本次抽取结果、支持前端抽取动画回放
ALTER TABLE draw_record
    ADD COLUMN order_id BIGINT NULL COMMENT '关联订单ID（盲盒订单支付触发抽取时写入）' AFTER box_id,
    ADD INDEX idx_draw_record_order (order_id);
