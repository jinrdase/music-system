package com.music.musicsystem.ai.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * AI 对话请求体。
 */
@Data
public class AiChatMessageDTO {

    @NotBlank(message = "消息内容不能为空")
    @Size(max = 1000, message = "单条消息不能超过 1000 字")
    private String message;
}
