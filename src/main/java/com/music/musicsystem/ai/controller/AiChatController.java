package com.music.musicsystem.ai.controller;

import com.music.musicsystem.ai.dto.AiChatMessageDTO;
import com.music.musicsystem.ai.service.AiChatService;
import com.music.musicsystem.common.result.Result;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

/**
 * AI 智能购物助手接口。
 * <p>
 * 流式对话返回 SSE（text/event-stream），每个 data 帧为一段增量文本，
 * 前端按到达顺序拼接即为完整回复；流结束（连接关闭）代表回复完成。
 */
@RestController
@RequestMapping("/api/ai/chat")
@RequiredArgsConstructor
public class AiChatController {

    private final AiChatService aiChatService;

    @PostMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> chatStream(@Valid @RequestBody AiChatMessageDTO dto, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return aiChatService.chatStream(userId, dto.getMessage().trim());
    }

    @PostMapping("/clear")
    public Result<Void> clear(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        aiChatService.clearConversation(userId);
        return Result.success("会话已清空", null);
    }
}
