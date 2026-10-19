package com.music.musicsystem.config;

import com.music.musicsystem.entity.AdminAuditLog;
import com.music.musicsystem.mapper.AdminAuditLogMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.time.LocalDateTime;

/**
 * 记录后台管理请求的操作审计信息。
 */

@Slf4j
@Component
@RequiredArgsConstructor
public class AdminAuditInterceptor implements HandlerInterceptor {
    private final AdminAuditLogMapper auditLogMapper;

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception exception) {
        String path = request.getRequestURI();
        String method = request.getMethod();
        if (!(path.startsWith("/api/admin/") || path.startsWith("/api/refund/admin/")
                || path.startsWith("/api/order/ship/"))
                || "GET".equalsIgnoreCase(method) || "HEAD".equalsIgnoreCase(method)) {
            return;
        }
        Object userId = request.getAttribute("userId");
        Object role = request.getAttribute("role");
        if (!(userId instanceof Long) || role == null) {
            return;
        }
        AdminAuditLog audit = new AdminAuditLog();
        audit.setOperatorUserId((Long) userId);
        audit.setOperatorRole(String.valueOf(role));
        audit.setHttpMethod(method);
        audit.setRequestPath(path);
        audit.setResponseStatus(response.getStatus());
        audit.setClientIp(request.getRemoteAddr());
        audit.setCreatedAt(LocalDateTime.now());
        try {
            auditLogMapper.insert(audit);
        } catch (Exception e) {
            log.warn("后台操作审计记录写入失败，path={}, status={}", path, response.getStatus());
        }
    }
}