package com.music.musicsystem.vo;

import lombok.Data;
import java.math.BigDecimal;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class PaymentVO {
    private String paymentNo;
    private String orderNo;
    private BigDecimal amount;
    private String payUrl; // 支付宝沙箱收银台地址（浏览器打开付款）
    private Long expireTime; // 过期时间戳（毫秒)
}