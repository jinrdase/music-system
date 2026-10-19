-- Run manually after reviewing and backing up the database.
-- This additive migration creates shipment metadata storage; it does not alter existing rows.
CREATE TABLE IF NOT EXISTS order_logistics (
    id BIGINT NOT NULL AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    order_no VARCHAR(64) NOT NULL,
    carrier VARCHAR(100) NOT NULL,
    tracking_no VARCHAR(100) NOT NULL,
    shipped_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_logistics_order_id (order_id),
    UNIQUE KEY uk_order_logistics_order_no (order_no),
    KEY idx_order_logistics_tracking_no (tracking_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
