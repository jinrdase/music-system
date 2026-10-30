
package com.music.musicsystem.dto;

import lombok.Data;
import jakarta.validation.constraints.NotNull;

/**
 * 创建支付入参。支付渠道已收敛为支付宝（2026-10-29 渠道决策），历史入参 paymentMethod 已移除；
 * 旧客户端多传该字段时会被 Jackson 忽略，不影响请求。
 */

@Data
public class PaymentDTO {

    @NotNull(message = "订单ID不能为空")
    private Long orderId;
}