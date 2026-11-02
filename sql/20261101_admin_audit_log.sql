-- Additive migration: install only after a verified backup and schema review.
-- Safe to re-run; this does not alter or delete existing business rows.
CREATE TABLE IF NOT EXISTS admin_audit_log (
    id BIGINT NOT NULL AUTO_INCREMENT,
    operator_user_id BIGINT NOT NULL,
    operator_role VARCHAR(32) NOT NULL,
    http_method VARCHAR(12) NOT NULL,
    request_path VARCHAR(500) NOT NULL,
    response_status INT NOT NULL,
    client_ip VARCHAR(64) NULL,
    created_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    KEY idx_admin_audit_created_at (created_at),
    KEY idx_admin_audit_operator (operator_user_id, created_at),
    KEY idx_admin_audit_method_created (http_method, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
