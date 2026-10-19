-- Review and apply manually; this script is not executed by the application.
-- Additive table for refund requests and their review/return-shipping information.
CREATE TABLE IF NOT EXISTS refund_application (
    id BIGINT NOT NULL AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    order_no VARCHAR(64) NOT NULL,
    user_id BIGINT NOT NULL,
    refund_amount DECIMAL(10, 2) NOT NULL,
    reason VARCHAR(100) NOT NULL,
    description VARCHAR(500) NULL,
    images JSON NULL,
    return_carrier VARCHAR(100) NULL,
    return_tracking_no VARCHAR(100) NULL,
    status TINYINT NOT NULL DEFAULT 0 COMMENT '0 pending, 1 approved, 2 rejected, 3 refunded',
    audit_remark VARCHAR(500) NULL,
    auditor_id BIGINT NULL,
    audit_time DATETIME NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_refund_application_user (user_id, create_time),
    KEY idx_refund_application_order (order_id, status),
    KEY idx_refund_application_status (status, create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
