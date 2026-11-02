package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.impl.ServiceImpl;
import com.music.musicsystem.entity.AdminAuditLog;
import com.music.musicsystem.mapper.AdminAuditLogMapper;
import com.music.musicsystem.service.AdminAuditLogService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;

@Service
public class AdminAuditLogServiceImpl extends ServiceImpl<AdminAuditLogMapper, AdminAuditLog>
        implements AdminAuditLogService {

    @Override
    public void record(Long operatorUserId, String operatorRole, String method,
                       String path, int responseStatus, String clientIp) {
        AdminAuditLog entry = new AdminAuditLog();
        entry.setOperatorUserId(operatorUserId);
        entry.setOperatorRole(operatorRole);
        entry.setHttpMethod(method);
        entry.setRequestPath(path);
        entry.setResponseStatus(responseStatus);
        entry.setClientIp(clientIp);
        entry.setCreatedAt(LocalDateTime.now());
        save(entry);
    }

    @Override
    public Page<AdminAuditLog> search(Integer current, Integer size, Long operatorUserId,
                                      String httpMethod, String requestPath,
                                      LocalDateTime from, LocalDateTime to) {
        int pageNumber = current == null || current < 1 ? 1 : current;
        int pageSize = size == null ? 20 : Math.max(1, Math.min(size, 100));
        LambdaQueryWrapper<AdminAuditLog> query = new LambdaQueryWrapper<AdminAuditLog>()
                .eq(operatorUserId != null, AdminAuditLog::getOperatorUserId, operatorUserId)
                .eq(StringUtils.hasText(httpMethod), AdminAuditLog::getHttpMethod,
                        StringUtils.hasText(httpMethod) ? httpMethod.toUpperCase() : null)
                .like(StringUtils.hasText(requestPath), AdminAuditLog::getRequestPath, requestPath)
                .ge(from != null, AdminAuditLog::getCreatedAt, from)
                .le(to != null, AdminAuditLog::getCreatedAt, to)
                .orderByDesc(AdminAuditLog::getCreatedAt);
        return page(new Page<>(pageNumber, pageSize), query);
    }
}
