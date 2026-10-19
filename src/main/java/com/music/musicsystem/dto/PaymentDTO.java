
package com.music.musicsystem.dto;

import lombok.Data;
import jakarta.validation.constraints.NotNull;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class PaymentDTO {

    @NotNull(message = "订单ID不能为空")
    private Long orderId;

    @NotNull(message = "支付方式不能为空")
    private Integer paymentMethod; // 1-微信，2-支付宝，3-余额
}