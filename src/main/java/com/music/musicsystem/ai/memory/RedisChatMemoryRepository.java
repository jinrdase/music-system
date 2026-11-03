package com.music.musicsystem.ai.memory;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.music.musicsystem.ai.config.AiConstants;
import com.music.musicsystem.ai.config.AiProperties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.memory.ChatMemoryRepository;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.MessageType;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Repository;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

/**
 * 基于 Redis 的会话记忆存储，替代 Spring AI 默认的内存实现。
 * <p>
 * 序列化时只保留 USER / ASSISTANT 两类纯文本消息：工具调用中间态
 * （AssistantMessage 的 tool_calls 与 ToolResponseMessage）不落库，
 * 避免回放到后续请求时出现"tool_calls 缺少配对 tool 消息"导致模型报错。
 * <p>
 * Boot 4 / Framework 7 默认装配的是 Jackson 3，类路径上没有 Jackson 2 的
 * ObjectMapper Bean，因此这里自建实例（仅序列化本类私有结构）。
 */
@Slf4j
@Repository
@RequiredArgsConstructor
public class RedisChatMemoryRepository implements ChatMemoryRepository {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    private final StringRedisTemplate redisTemplate;
    private final AiProperties aiProperties;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    record MessageRecord(String type, String text) {
    }

    @Override
    public List<String> findConversationIds() {
        List<String> ids = new ArrayList<>();
        redisTemplate.keys(AiConstants.MEMORY_KEY_PREFIX + "*")
                .forEach(key -> ids.add(key.substring(AiConstants.MEMORY_KEY_PREFIX.length())));
        return ids;
    }

    @Override
    public List<Message> findByConversationId(String conversationId) {
        String json = redisTemplate.opsForValue().get(key(conversationId));
        if (json == null || json.isBlank()) {
            return List.of();
        }
        try {
            List<MessageRecord> records = OBJECT_MAPPER.readValue(json, new TypeReference<>() {
            });
            List<Message> messages = new ArrayList<>(records.size());
            for (MessageRecord record : records) {
                if (record == null || record.text() == null || record.text().isBlank()) {
                    continue;
                }
                if (MessageType.USER.name().equals(record.type())) {
                    messages.add(new UserMessage(record.text()));
                } else if (MessageType.ASSISTANT.name().equals(record.type())) {
                    messages.add(new AssistantMessage(record.text()));
                }
            }
            return messages;
        } catch (Exception e) {
            log.warn("AI 会话记忆反序列化失败，按空会话处理：{}", conversationId, e);
            return List.of();
        }
    }

    @Override
    public void saveAll(String conversationId, List<Message> messages) {
        List<MessageRecord> records = new ArrayList<>(messages.size());
        for (Message message : messages) {
            MessageType type = message.getMessageType();
            if (type == MessageType.USER || type == MessageType.ASSISTANT) {
                String text = message.getText();
                if (text != null && !text.isBlank()) {
                    records.add(new MessageRecord(type.name(), text));
                }
            }
        }
        try {
            String json = OBJECT_MAPPER.writeValueAsString(records);
            redisTemplate.opsForValue().set(key(conversationId), json,
                    Duration.ofDays(aiProperties.getTtlDays()));
        } catch (Exception e) {
            log.warn("AI 会话记忆写入失败：{}", conversationId, e);
        }
    }

    @Override
    public void deleteByConversationId(String conversationId) {
        redisTemplate.delete(key(conversationId));
    }

    private String key(String conversationId) {
        return AiConstants.MEMORY_KEY_PREFIX + conversationId;
    }
}
