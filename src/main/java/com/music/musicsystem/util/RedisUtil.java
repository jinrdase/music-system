package com.music.musicsystem.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * 封装 Redis 键值、过期时间和集合操作。
 * 基于 StringRedisTemplate：值以字符串存储，
 * 保证 increment/decrement 等计数操作可直接执行。
 */

@Component
public class RedisUtil {

    @Autowired
    private StringRedisTemplate redisTemplate;

    /**
     * 设置缓存
     */
    public void set(String key, Object value) {
        redisTemplate.opsForValue().set(key, String.valueOf(value));
    }

    /**
     * 设置缓存并设置过期时
     */
    public void set(String key, Object value, long timeout, TimeUnit unit) {
        redisTemplate.opsForValue().set(key, String.valueOf(value), timeout, unit);
    }

    /**
     * 获取缓存
     */
    public Object get(String key) {
        return redisTemplate.opsForValue().get(key);
    }

    /**
     * 删除缓存
     */
    public Boolean delete(String key) {
        return redisTemplate.delete(key);
    }

    /**
     * 递减缓存值。
     */
    public Long decrement(String key, long delta) {
        return redisTemplate.opsForValue().decrement(key, delta);
    }

    /**
     * 递增缓存值。
     */
    public Long increment(String key, long delta) {
        return redisTemplate.opsForValue().increment(key, delta);
    }

    /**
     * 判断key是否存在
     */
    public Boolean hasKey(String key) {
        return redisTemplate.hasKey(key);
    }
}