package com.music.musicsystem.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 负责 JWT 密钥初始化、令牌生成、解析和验证。
 * 用于生成、解析和验证 JWT Token
 */
@Component
public class JwtUtil {

    @Value("${jwt.secret:musicSystemSecretKey2026ForJwtTokenMustBeAtLeast64BytesLongForHS512AlgorithmSecurity}")
    private String secret;

    @Value("${jwt.expiration:604800000}")
    private Long expiration; // 7天（毫秒）

    @Value("${jwt.refresh-expiration:1209600000}")
    private Long refreshExpiration; // 14天（毫秒

    /**
     * 生成密钥
     * 使用 HMAC-SHA 算法签名。
     */
    private SecretKey getSecretKey() {
        return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * 生成访问 Token
     *
     * @param userId 用户ID
     * @param username 用户
     * @param role 用户角色
     * @return JWT Token 字符
     */
    public String generateToken(Long userId, String username, String role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("username", username);
        claims.put("role", role);
        claims.put("type", "access");

        return createToken(claims, username, expiration);
    }

    /**
     * 生成刷新 Token
     *
     * @param userId 用户ID
     * @param username 用户
     * @return 刷新 Token 字符
     */
    public String generateRefreshToken(Long userId, String username) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("username", username);
        claims.put("type", "refresh");

        return createToken(claims, username, refreshExpiration);
    }

    /**
     * 创建 Token 的通用方法
     *
     * @param claims 自定义声
     * @param subject 主题（通常是用户名
     * @param expirationTime 过期时间（毫秒）
     * @return JWT Token 字符
     */
    private String createToken(Map<String, Object> claims, String subject, Long expirationTime) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expirationTime);

        return Jwts.builder()
                .claims(claims)
                .subject(subject)
                .issuedAt(now)
                .expiration(expiryDate)
                .signWith(getSecretKey())
                .compact();
    }

    /**
     * 解析 Token。
     *
     * @param token JWT Token
     * @return Claims 对象，包Token 中的所有声
     * @throws JwtException 如果 Token 无效或过
     */
    public Claims parseToken(String token) {
        return Jwts.parser()
                .verifyWith(getSecretKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * Token 获取用户ID
     *
     * @param token JWT Token
     * @return 用户ID
     */
    public Long getUserIdFromToken(String token) {
        Claims claims = parseToken(token);
        Object userIdObj = claims.get("userId");

        if (userIdObj instanceof Integer) {
            return ((Integer) userIdObj).longValue();
        }
        return (Long) userIdObj;
    }

    /**
     * Token 获取用户
     *
     * @param token JWT Token
     * @return 用户
     */
    public String getUsernameFromToken(String token) {
        Claims claims = parseToken(token);
        return claims.getSubject();
    }

    /**
     * Token 获取角色
     *
     * @param token JWT Token
     * @return 用户角色
     */
    public String getRoleFromToken(String token) {
        Claims claims = parseToken(token);
        return (String) claims.get("role");
    }

    /**
     * Token 获取 Token 类型
     *
     * @param token JWT Token
     * @return Token 类型（access refresh
     */
    public String getTokenType(String token) {
        Claims claims = parseToken(token);
        return (String) claims.get("type");
    }

    /**
     * 验证 Token 是否过期。
     *
     * @param token JWT Token
     * @return true 表示令牌已过期，false 表示令牌尚未过期
     */
    public boolean isTokenExpired(String token) {
        try {
            Claims claims = parseToken(token);
            return claims.getExpiration().before(new Date());
        } catch (ExpiredJwtException e) {
            return true;
        } catch (Exception e) {
            return true;
        }
    }

    /**
     * 验证 Token 是否有效。
     * 检Token 格式、签名和过期时间
     *
     * @param token JWT Token
     * @return true 表示有效，false 表示无效
     */
    public boolean validateToken(String token) {
        try {
            parseToken(token);
            return !isTokenExpired(token);
        } catch (ExpiredJwtException e) {
            // 令牌已过期
            return false;
        } catch (JwtException e) {
            // Token 格式错误或签名无
            return false;
        } catch (Exception e) {
            // 其他异常
            return false;
        }
    }

    /**
     * 验证 Token 是否有效且属于指定用
     *
     * @param token JWT Token
     * @param username 用户
     * @return true 表示有效且匹配，false 表示无效或不匹配
     */
    public boolean validateToken(String token, String username) {
        try {
            String tokenUsername = getUsernameFromToken(token);
            return tokenUsername.equals(username) && !isTokenExpired(token);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 刷新 Token
     * 使用刷新 Token 生成新的访问 Token
     *
     * @param refreshToken 刷新 Token
     * @return 新的访问 Token
     * @throws IllegalArgumentException 如果刷新 Token 无效或不是刷新类
     */
    public String refreshAccessToken(String refreshToken) {
        try {
            Claims claims = parseToken(refreshToken);
            String tokenType = (String) claims.get("type");

            if (!"refresh".equals(tokenType)) {
                throw new IllegalArgumentException("提供的Token不是刷新Token");
            }

            Long userId = getUserIdFromToken(refreshToken);
            String username = getUsernameFromToken(refreshToken);

            // 从数据库或缓存获取用户角色（这里简化处理）
            // 实际应用中应该查询数据库获取最新的用户角色
            String role = "USER"; // 默认角色

            return generateToken(userId, username, role);
        } catch (Exception e) {
            throw new IllegalArgumentException("刷新 Token 无效或已过期", e);
        }
    }

    /**
     * Token 获取过期时间
     *
     * @param token JWT Token
     * @return 过期时间
     */
    public Date getExpirationDateFromToken(String token) {
        Claims claims = parseToken(token);
        return claims.getExpiration();
    }

    /**
     * Token 获取签发时间
     *
     * @param token JWT Token
     * @return 签发时间
     */
    public Date getIssuedAtFromToken(String token) {
        Claims claims = parseToken(token);
        return claims.getIssuedAt();
    }

    /**
     * 获取 Token 剩余有效时间（毫秒）
     *
     * @param token JWT Token
     * @return 剩余有效时间（毫秒），如果已过期返回 0
     */
    public Long getRemainingValidityTime(String token) {
        try {
            Date expirationDate = getExpirationDateFromToken(token);
            Date now = new Date();
            long remainingTime = expirationDate.getTime() - now.getTime();
            return Math.max(0, remainingTime);
        } catch (Exception e) {
            return 0L;
        }
    }

    /**
     * 检Token 是否即将过期
     *
     * @param token JWT Token
     * @param thresholdMinutes 阈值（分钟
     * @return true 表示即将过期（剩余时间小于阈值），false 表示还有充足时间
     */
    public boolean isTokenExpiringSoon(String token, int thresholdMinutes) {
        try {
            Long remainingTime = getRemainingValidityTime(token);
            long thresholdMillis = thresholdMinutes * 60 * 1000L;
            return remainingTime > 0 && remainingTime <= thresholdMillis;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Token 中提取所有自定义声明
     *
     * @param token JWT Token
     * @return 包含所有自定义声明Map
     */
    public Map<String, Object> extractAllClaims(String token) {
        Claims claims = parseToken(token);
        Map<String, Object> claimsMap = new HashMap<>();

        claimsMap.put("userId", claims.get("userId"));
        claimsMap.put("username", claims.getSubject());
        claimsMap.put("role", claims.get("role"));
        claimsMap.put("type", claims.get("type"));
        claimsMap.put("issuedAt", claims.getIssuedAt());
        claimsMap.put("expiration", claims.getExpiration());

        return claimsMap;
    }

    /**
     * 检Token 格式是否正确（简单检查）
     *
     * @param token JWT Token
     * @return true 表示格式正确，false 表示格式错误
     */
    public boolean isValidTokenFormat(String token) {
        if (token == null || token.trim().isEmpty()) {
            return false;
        }

        // JWT 格式应该是三个部分，. 分隔
        String[] parts = token.split("\\.");
        return parts.length == 3;
    }

    /**
     * 移除 Token 前缀（如果存在）
     * 例如：移"Bearer " 前缀
     *
     * @param token 可能带有前缀Token
     * @return 去除前缀后的Token
     */
    public String removeBearerPrefix(String token) {
        if (token != null && token.startsWith("Bearer ")) {
            return token.substring(7);
        }
        return token;
    }

    /**
     * 获取配置的过期时间（毫秒
     *
     * @return 访问 Token 过期时间
     */
    public Long getExpiration() {
        return expiration;
    }

    /**
     * 获取配置的刷新过期时间（毫秒
     *
     * @return 刷新 Token 过期时间
     */
    public Long getRefreshExpiration() {
        return refreshExpiration;
    }
}