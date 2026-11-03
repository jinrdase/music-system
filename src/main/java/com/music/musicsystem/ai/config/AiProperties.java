package com.music.musicsystem.ai.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * AI 助手配置项（ai.chat.*）。
 */
@Data
@Component
@ConfigurationProperties(prefix = "ai.chat")
public class AiProperties {

    /** 多轮记忆窗口：保留最近 N 条消息 */
    private int windowSize = 20;

    /** Redis 会话记忆保留天数 */
    private int ttlDays = 7;

    /** 单次流式回复超时（秒） */
    private int timeoutSeconds = 60;
}
