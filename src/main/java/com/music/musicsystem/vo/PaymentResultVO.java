package com.music.musicsystem.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class PaymentResultVO {
    private String paymentNo;
    private String orderNo;
    private BigDecimal amount;
    private Integer status; // 0-待支付，1-支付成功-支付失败
    private String transactionId;
    private LocalDateTime payTime;
}