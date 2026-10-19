package com.music.musicsystem.controller;

import com.music.musicsystem.common.result.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 提供服务健康检查和联调测试接口。
 */

@RestController
@RequestMapping("/api/test")
public class TestController {
    /**
     * 返回服务运行状态及测试信息。
     */

    @GetMapping("/hello")
    public Result<Map<String, Object>> hello() {
        Map<String, Object> data = new HashMap<>();
        data.put("message", "潮流音乐专辑及衍生品发售系统");
        data.put("version", "1.0.0");
        data.put("time", LocalDateTime.now());
        return Result.success("系统运行正常", data);
    }
}