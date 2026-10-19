package com.music.musicsystem.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import java.nio.file.Path;

/**
 * 注册请求拦截器并配置静态资源映射。
 */

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private JwtInterceptor jwtInterceptor;

    @Autowired
    private AdminAuditInterceptor adminAuditInterceptor;

    @Value("${music.upload.directory:${user.home}/music-system-uploads}")
    private String uploadDirectory;
    /**
     * 注册应用使用的请求拦截器及其路径范围。
     */

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/api/**")  // 拦截所有 /api/** 请求
                .excludePathPatterns(
                        "/api/user/register",   // 放行注册
                        "/api/user/login",      // 放行登录
                        "/api/test/**",         // 放行测试接口
                        "/api/payment/notify/**"  // 放行支付回调
                );
        registry.addInterceptor(adminAuditInterceptor).addPathPatterns("/api/**");
    }
    /**
     * 配置静态资源的访问映射。
     */

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String location = Path.of(uploadDirectory).toAbsolutePath().normalize().toUri().toString();
        if (!location.endsWith("/")) {
            location += "/";
        }
        registry.addResourceHandler("/media/**").addResourceLocations(location);
    }
}