package com.music.musicsystem.config;

import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.util.JwtUtil;
import com.music.musicsystem.service.AdminAuditLogService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 校验请求中的 JWT，并设置当前用户身份信息。
 */

@Component
public class JwtInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AdminAuditLogService adminAuditLogService;
    /**
     * 校验请求中的身份令牌，并向后续处理器传递用户身份。
     */

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. 从请求头获取 Token
        String token = request.getHeader("Authorization");

        if (token == null || token.isEmpty()) {
            throw new BusinessException(401, "未登录，请先登录");
        }

        // 2. 去掉 Bearer 前缀（如果有
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        // 3. 解析 Token
        try {
            if (jwtUtil.isTokenExpired(token)) {
                throw new BusinessException(401, "登录令牌已过期，请重新登录");
            }

            // 4. 解析成功，将用户信息放入请求属性
            Long userId = jwtUtil.getUserIdFromToken(token);
            String username = jwtUtil.getUsernameFromToken(token);
            String role = jwtUtil.getRoleFromToken(token);

            request.setAttribute("userId", userId);
            request.setAttribute("username", username);
            request.setAttribute("role", role);

            return true;

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException(401, "Token 无效，请重新登录");
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) {
        String path = request.getRequestURI();
        boolean adminApi = path.startsWith("/api/admin/")
                && !path.startsWith("/api/admin/audit-logs");
        // These administrative actions intentionally live outside /api/admin/**.
        boolean adminOrderShipment = path.startsWith("/api/order/ship/");
        boolean adminRefundAction = path.startsWith("/api/refund/admin/");
        if (!adminApi && !adminOrderShipment && !adminRefundAction) {
            return;
        }
        Object userId = request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        if (!(userId instanceof Long id)
                || (!"admin".equalsIgnoreCase(role) && !"super_admin".equalsIgnoreCase(role))) {
            return;
        }
        try {
            adminAuditLogService.record(id, role, request.getMethod(), path,
                    response.getStatus(), request.getRemoteAddr());
        } catch (Exception auditFailure) {
            // Auditing must not turn an otherwise completed admin request into a failure.
            org.slf4j.LoggerFactory.getLogger(JwtInterceptor.class)
                    .error("管理员审计日志写入失败：path={}, operatorId={}", path, id, auditFailure);
        }
    }
}
