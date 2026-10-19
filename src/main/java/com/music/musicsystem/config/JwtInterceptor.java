package com.music.musicsystem.config;

import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.util.JwtUtil;
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

        // 3. 楠岃瘉 Token
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
}