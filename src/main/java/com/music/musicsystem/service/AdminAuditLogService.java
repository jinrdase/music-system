package com.music.musicsystem.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.entity.AdminAuditLog;

import java.time.LocalDateTime;

public interface AdminAuditLogService {
    void record(Long operatorUserId, String operatorRole, String method,
                String path, int responseStatus, String clientIp);

    Page<AdminAuditLog> search(Integer current, Integer size, Long operatorUserId,
                               String httpMethod, String requestPath,
                               LocalDateTime from, LocalDateTime to);
}
