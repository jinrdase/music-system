-- 二期第三批（F-4.3 购物车合并结算 / F-4.2 盲盒订单结构前置）
-- 1) 新增订单明细表 order_item：一行对应一件已购专辑，多商品订单的明细载体；
--    digital_content_accessed_at 由订单级迁移到明细级（退款闸门）。
-- 2) order_info 扩展列：order_type 区分专辑/盲盒订单；blind_box_id/draw_count/draw_summary
--    为第四批盲盒订单预留。
-- 历史订单兼容：order_info 保留单商品列，无明细的旧订单按订单级字段处理。

CREATE TABLE `order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `order_no` varchar(50) NOT NULL COMMENT '订单号',
  `album_id` bigint NOT NULL COMMENT '专辑ID',
  `album_title` varchar(100) NOT NULL COMMENT '专辑名称快照',
  `album_cover` varchar(255) DEFAULT NULL COMMENT '专辑封面快照',
  `price` decimal(10,2) NOT NULL COMMENT '成交单价快照',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '购买数量',
  `subtotal` decimal(10,2) NOT NULL COMMENT '小计=单价x数量',
  `product_type` varchar(16) NOT NULL DEFAULT 'PHYSICAL' COMMENT '商品形态快照：PHYSICAL-实物，DIGITAL-数字',
  `digital_content_accessed_at` datetime DEFAULT NULL COMMENT '数字内容首次取阅时间（明细级退款闸门）',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单明细表（多商品订单）';

ALTER TABLE `order_info`
    ADD COLUMN `order_type` tinyint NOT NULL DEFAULT 1 COMMENT '订单形态：1-专辑订单，2-盲盒订单' AFTER `status`,
    ADD COLUMN `blind_box_id` bigint DEFAULT NULL COMMENT '盲盒订单关联的盲盒ID' AFTER `order_type`,
    ADD COLUMN `draw_count` int DEFAULT NULL COMMENT '盲盒订单抽取次数（1或10）' AFTER `blind_box_id`,
    ADD COLUMN `draw_summary` varchar(1000) DEFAULT NULL COMMENT '盲盒抽取结果摘要' AFTER `draw_count`;
