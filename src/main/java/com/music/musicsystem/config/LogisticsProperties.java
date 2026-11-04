package com.music.musicsystem.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 快递100 物流轨迹查询配置项（logistics.kuaidi100.*）。
 */
@Data
@Component
@ConfigurationProperties(prefix = "logistics.kuaidi100")
public class LogisticsProperties {

    /** 轨迹查询开关：未配置授权时为 false，接口自动降级（仅返回承运商与单号） */
    private boolean enabled = false;

    /** 快递100 授权 key */
    private String key;

    /** 快递100 客户编号 */
    private String customer;

    /** 查询端点（可切官方沙箱做演示） */
    private String url = "https://poll.kuaidi100.com/poll/query.do";

    /** 轨迹 Redis 缓存时长（分钟） */
    private int cacheTtlMinutes = 30;
}
