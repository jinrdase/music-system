package com.music.musicsystem.ai.config;

/**
 * AI 模块通用常量。
 */
public final class AiConstants {

    /** ToolContext 中传递当前登录用户 ID 的键（由 Controller 从 JWT 拦截器属性注入，不交给 LLM） */
    public static final String TOOL_CONTEXT_USER_ID = "userId";

    /** Redis 会话记忆 key 前缀，完整 key：chat:memory:{conversationId} */
    public static final String MEMORY_KEY_PREFIX = "chat:memory:";

    private AiConstants() {
    }
}
