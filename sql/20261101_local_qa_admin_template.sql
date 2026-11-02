-- Local-only QA administrator insertion template.
-- Review and obtain explicit approval before executing against music_system.
-- Set @qa_admin_password in this SQL session to a new high-entropy test password;
-- do not save the password in this file or Navicat query history.
-- Existing users are never updated. If username already exists, this inserts no row.
SET @qa_admin_username = 'qa_admin_local';
SET @qa_admin_password = NULL;

INSERT INTO sys_user
    (username, password, nickname, status, role, deleted, create_time, update_time)
SELECT
    @qa_admin_username,
    MD5(CONCAT(@qa_admin_password, 'music_system_salt_2026')),
    'QA 管理员（本地测试）',
    1,
    'admin',
    0,
    NOW(),
    NOW()
FROM DUAL
WHERE @qa_admin_password IS NOT NULL
  AND CHAR_LENGTH(@qa_admin_password) >= 20
  AND NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'qa_admin_local');

SET @qa_admin_password = NULL;
