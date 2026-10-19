package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.dto.PaymentDTO;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.entity.Payment;
import com.music.musicsystem.mapper.OrderInfoMapper;
import com.music.musicsystem.mapper.PaymentMapper;
import com.music.musicsystem.service.OrderService;
import com.music.musicsystem.service.PaymentService;
import com.music.musicsystem.vo.PaymentResultVO;
import com.music.musicsystem.vo.PaymentVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

/**
 * 实现支付单创建、结果查询和渠道回调处理。
 */

@Service
public class PaymentServiceImpl implements PaymentService {

    @Resource
    private PaymentMapper paymentMapper;

    @Resource
    private OrderInfoMapper orderInfoMapper;

    @Resource
    private OrderService orderService;

    private static final Long PAYMENT_TIMEOUT = 15 * 60 * 1000L; // 15分钟
    /**
     * 为订单创建支付记录和支付信息。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PaymentVO createPayment(Long userId, PaymentDTO dto) {
        // 1. 校验订单
        OrderInfo order = orderInfoMapper.selectById(dto.getOrderId());
        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        if (!order.getUserId().equals(userId)) {
            throw new BusinessException("无权操作该订单");
        }
        if (order.getStatus() != 0) {
            throw new BusinessException("订单状态异常，无法支付");
        }

        // 2. 检查是否已有待支付记录
        Payment existingPayment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>()
                        .eq(Payment::getOrderId, dto.getOrderId())
                        .eq(Payment::getStatus, 0)
        );

        if (existingPayment != null) {
            // 如果存在且未过期，返回已有支付信
            if (existingPayment.getCreateTime().plusMinutes(15).isAfter(LocalDateTime.now())) {
                return buildPaymentVO(existingPayment, dto.getPaymentMethod());
            }
            // 已过期，取消旧支
            existingPayment.setStatus(2);
            paymentMapper.updateById(existingPayment);
        }

        // 3. 创建支付记录
        Payment payment = new Payment();
        payment.setPaymentNo(generatePaymentNo());
        payment.setOrderId(order.getId());
        payment.setOrderNo(order.getOrderNo());
        payment.setUserId(userId);
        payment.setAmount(order.getTotalAmount());
        payment.setPaymentMethod(dto.getPaymentMethod());
        payment.setStatus(0);
        paymentMapper.insert(payment);

        // 4. 调用第三方支付接
        PaymentVO vo = buildPaymentVO(payment, dto.getPaymentMethod());

        switch (dto.getPaymentMethod()) {
            case 1: // 寰俊鏀粯
                vo.setQrCodeUrl(createWechatPayOrder(payment));
                break;
            case 2: // 鏀粯瀹
                vo.setPayUrl(createAlipayOrder(payment));
                break;
            case 3: // 余额支付（暂未实现）
                throw new BusinessException("余额支付功能暂未开放");
            default:
                throw new BusinessException("不支持的支付方式");
        }

        vo.setExpireTime(System.currentTimeMillis() + PAYMENT_TIMEOUT);
        return vo;
    }
    /**
     * 查询指定支付的处理结果。
     */

    @Override
    public PaymentResultVO queryPaymentResult(String paymentNo) {
        Payment payment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>().eq(Payment::getPaymentNo, paymentNo)
        );

        if (payment == null) {
            throw new BusinessException("支付记录不存在");
        }

        PaymentResultVO vo = new PaymentResultVO();
        BeanUtils.copyProperties(payment, vo);
        return vo;
    }
    /**
     * 处理微信支付平台的异步通知。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void wechatPayCallback(Map<String, String> params) {
        // 1. 验证签名（实际项目中需要验证微信签名）
        String paymentNo = params.get("out_trade_no");
        String transactionId = params.get("transaction_id");
        String resultCode = params.get("result_code");

        if (!"SUCCESS".equals(resultCode)) {
            return;
        }

        // 2. 查询支付记录
        Payment payment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>().eq(Payment::getPaymentNo, paymentNo)
        );

        if (payment == null || payment.getStatus() == 1) {
            return; // 防止重复回调
        }

        // 3. 更新支付状
        payment.setStatus(1);
        payment.setTransactionId(transactionId);
        payment.setPayTime(LocalDateTime.now());
        payment.setNotifyData(params.toString());
        paymentMapper.updateById(payment);

        // 4. 更新订单状
        orderService.handlePaymentSuccess(payment.getOrderId());
    }
    /**
     * 处理支付宝的异步通知。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void alipayCallback(Map<String, String> params) {
        // 1. 验证签名（实际项目中需要验证支付宝签名
        String paymentNo = params.get("out_trade_no");
        String transactionId = params.get("trade_no");
        String tradeStatus = params.get("trade_status");

        if (!"TRADE_SUCCESS".equals(tradeStatus)) {
            return;
        }

        // 2. 查询支付记录
        Payment payment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>().eq(Payment::getPaymentNo, paymentNo)
        );

        if (payment == null || payment.getStatus() == 1) {
            return;
        }

        // 3. 更新支付状
        payment.setStatus(1);
        payment.setTransactionId(transactionId);
        payment.setPayTime(LocalDateTime.now());
        payment.setNotifyData(params.toString());
        paymentMapper.updateById(payment);

        // 4. 更新订单状
        orderService.handlePaymentSuccess(payment.getOrderId());
    }
    /**
     * 取消尚未完成的支付并同步订单状态。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelPayment(Long userId, String paymentNo) {
        Payment payment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>().eq(Payment::getPaymentNo, paymentNo)
        );

        if (payment == null) {
            throw new BusinessException("支付记录不存在");
        }
        if (!payment.getUserId().equals(userId)) {
            throw new BusinessException("无权操作该支付");
        }
        if (payment.getStatus() != 0) {
            throw new BusinessException("该支付已完成，无法取消");
        }

        payment.setStatus(2);
        paymentMapper.updateById(payment);
    }

    /**
     * 生成支付流水
     */
    private String generatePaymentNo() {
        return "PAY" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    /**
     * 鏋勫缓鏀粯VO
     */
    private PaymentVO buildPaymentVO(Payment payment, Integer paymentMethod) {
        PaymentVO vo = new PaymentVO();
        vo.setPaymentNo(payment.getPaymentNo());
        vo.setOrderNo(payment.getOrderNo());
        vo.setAmount(payment.getAmount());
        vo.setPaymentMethod(paymentMethod);
        return vo;
    }

    /**
     * 创建微信支付订单（模拟）
     * 实际项目中需调用微信支付API
     */
    private String createWechatPayOrder(Payment payment) {
        // TODO: 调用微信支付统一下单接口
        // 杩斿洖浜岀淮鐮乁RL
        return "weixin://wxpay/bizpayurl?pr=" + payment.getPaymentNo();
    }

    /**
     * 创建支付宝订单（模块拟
     * 实际项目中需调用支付宝API
     */
    private String createAlipayOrder(Payment payment) {
        // TODO: 调用支付宝手机网站支付接
        // 杩斿洖鏀粯URL
        return "https://openapi.alipay.com/gateway.do?trade_no=" + payment.getPaymentNo();
    }
}