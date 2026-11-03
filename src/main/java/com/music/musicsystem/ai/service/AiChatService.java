package com.music.musicsystem.ai.service;

import com.music.musicsystem.ai.config.AiProperties;
import com.music.musicsystem.ai.memory.RedisChatMemoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.time.Duration;
import java.util.Map;

/**
 * AI 购物助手编排：多轮记忆 + 工具调用 + 流式输出。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AiChatService {

    private final ChatClient chatClient;
    private final ChatMemory chatMemory;
    private final RedisChatMemoryRepository chatMemoryRepository;
    private final AiProperties aiProperties;

    /**
     * 流式对话：按用户隔离会话记忆，userId 通过 ToolContext 传给工具，不暴露给模型。
     * 任何异常（模型超时、供应商故障等）都降级为一句兜底文案，绝不影响主购买链路。
     */
    public Flux<String> chatStream(Long userId, String message) {
        String conversationId = conversationId(userId);
        return chatClient.prompt()
                .user(message)
                .advisors(advisor -> advisor.param(ChatMemory.CONVERSATION_ID, conversationId))
                .toolContext(Map.of("userId", userId))
                .stream()
                .content()
                .timeout(Duration.ofSeconds(aiProperties.getTimeoutSeconds()))
                .onErrorResume(e -> {
                    log.warn("AI 流式对话异常：userId={}", userId, e);
                    return Flux.just("\n\n[AI 助手暂时不可用，请稍后再试]");
                });
    }

    /** 清空指定用户的会话记忆 */
    public void clearConversation(Long userId) {
        chatMemoryRepository.deleteByConversationId(conversationId(userId));
    }

    private String conversationId(Long userId) {
        return "user-" + userId;
    }
}
