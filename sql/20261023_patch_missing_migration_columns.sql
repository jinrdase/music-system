-- 补齐伙伴 music_system.sql 缺失的迁移列（对应 20261019_catalog_order_fulfillment.sql，
-- 但对方脚本已含 order_info.receiver_* 列，原样执行会因重复列失败，故精准补缺失的 5 列）
-- 执行日期：2026-10-23
USE music_system;

ALTER TABLE album
    ADD COLUMN product_type VARCHAR(16) NOT NULL DEFAULT 'PHYSICAL' COMMENT 'PHYSICAL or DIGITAL',
    ADD COLUMN digital_content_url VARCHAR(2000) NULL COMMENT 'Private digital delivery target';

ALTER TABLE order_info
    ADD COLUMN product_type VARCHAR(16) NOT NULL DEFAULT 'PHYSICAL' COMMENT 'Product type captured at order creation',
    ADD COLUMN digital_content_accessed_at DATETIME NULL;

ALTER TABLE draw_record
    ADD COLUMN probability_at_draw DECIMAL(10, 6) NULL COMMENT 'Configured probability captured for audit';
