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
    private Integer paymentMethod;
    private String qrCodeUrl; // 二维码URL（扫码支付）
    private String payUrl; // H5鏀粯URL
    private Long expireTime; // 过期时间戳（毫秒
}