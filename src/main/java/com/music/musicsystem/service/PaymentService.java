package com.music.musicsystem.service;

import com.music.musicsystem.dto.PaymentDTO;
import com.music.musicsystem.vo.PaymentResultVO;
import com.music.musicsystem.vo.PaymentVO;

import java.util.Map;

/**
 * 定义支付创建、查询和回调处理操作。
 */

public interface PaymentService {

    /**
     * 创建支付订单
     */
    PaymentVO createPayment(Long userId, PaymentDTO dto);

    /**
     * 查询支付结果
     */
    PaymentResultVO queryPaymentResult(String paymentNo);

    /**
     * 微信支付回调。
     */
    void wechatPayCallback(Map<String, String> params);

    /**
     * 支付宝支付回
     */
    void alipayCallback(Map<String, String> params);

    /**
     * 取消支付
     */
    void cancelPayment(Long userId, String paymentNo);
}