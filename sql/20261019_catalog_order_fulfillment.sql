-- Run manually after reviewing and backing up the music_system database.
-- Existing album rows remain physical products for backward compatibility.
ALTER TABLE album
    ADD COLUMN product_type VARCHAR(16) NOT NULL DEFAULT 'PHYSICAL' COMMENT 'PHYSICAL or DIGITAL',
    ADD COLUMN digital_content_url VARCHAR(2000) NULL COMMENT 'Private digital delivery target';

ALTER TABLE order_info
    ADD COLUMN product_type VARCHAR(16) NOT NULL DEFAULT 'PHYSICAL' COMMENT 'Product type captured at order creation',
    ADD COLUMN receiver_name VARCHAR(100) NULL,
    ADD COLUMN receiver_phone VARCHAR(32) NULL,
    ADD COLUMN receiver_province VARCHAR(100) NULL,
    ADD COLUMN receiver_city VARCHAR(100) NULL,
    ADD COLUMN receiver_district VARCHAR(100) NULL,
    ADD COLUMN receiver_address VARCHAR(500) NULL,
    ADD COLUMN digital_content_accessed_at DATETIME NULL;

ALTER TABLE draw_record
    ADD COLUMN probability_at_draw DECIMAL(10, 6) NULL COMMENT 'Configured probability captured for audit';
