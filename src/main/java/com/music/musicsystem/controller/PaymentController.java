package com.music.musicsystem.controller;

import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.PaymentDTO;
import com.music.musicsystem.service.PaymentService;
import com.music.musicsystem.util.JwtUtil;
import com.music.musicsystem.vo.PaymentResultVO;
import com.music.musicsystem.vo.PaymentVO;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 处理支付创建、结果查询和支付平台回调请求。
 */

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

    @Resource
    private PaymentService paymentService;

    @Resource
    private JwtUtil jwtUtil;

    /**
     * 创建支付订单
     */
    @PostMapping("/create")
    public Result<PaymentVO> createPayment(@Validated @RequestBody PaymentDTO dto,
                                           HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        PaymentVO vo = paymentService.createPayment(userId, dto);
        return Result.success(vo);
    }

    /**
     * 查询支付结果
     */
    @GetMapping("/query/{paymentNo}")
    public Result<PaymentResultVO> queryPaymentResult(@PathVariable String paymentNo) {
        PaymentResultVO vo = paymentService.queryPaymentResult(paymentNo);
        return Result.success(vo);
    }

    /**
     * 取消支付
     */
    @PostMapping("/cancel/{paymentNo}")
    public Result<Void> cancelPayment(@PathVariable String paymentNo,
                                      HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        paymentService.cancelPayment(userId, paymentNo);
        return Result.success();
    }

    /**
     * 微信支付回调（异步通知
     */
    @PostMapping("/notify/wechat")
    public String wechatPayNotify(@RequestParam Map<String, String> params) {
        try {
            paymentService.wechatPayCallback(params);
            return "<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>";
        } catch (Exception e) {
            return "<xml><return_code><![CDATA[FAIL]]></return_code></xml>";
        }
    }

    /**
     * 支付宝支付回调（异步通知
     */
    @PostMapping("/notify/alipay")
    public String alipayNotify(@RequestParam Map<String, String> params) {
        try {
            paymentService.alipayCallback(params);
            return "success";
        } catch (Exception e) {
            return "fail";
        }
    }

    /**
     * 从Token获取当前用户ID
     */
    private Long getCurrentUserId(HttpServletRequest request) {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        return jwtUtil.getUserIdFromToken(token);
    }
}