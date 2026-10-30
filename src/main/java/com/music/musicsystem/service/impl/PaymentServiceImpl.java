package com.music.musicsystem.service.impl;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.alipay.api.request.AlipayTradeQueryRequest;
import com.alipay.api.response.AlipayTradePagePayResponse;
import com.alipay.api.response.AlipayTradeQueryResponse;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.music.musicsystem.common.constant.PaymentStatus;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.config.AlipayClientProvider;
import com.music.musicsystem.config.AlipayProperties;
import com.music.musicsystem.dto.PaymentDTO;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.entity.Payment;
import com.music.musicsystem.mapper.OrderInfoMapper;
import com.music.musicsystem.mapper.PaymentMapper;
import com.music.musicsystem.service.OrderService;
import com.music.musicsystem.service.PaymentService;
import com.music.musicsystem.vo.PaymentResultVO;
import com.music.musicsystem.vo.PaymentVO;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

/**
 * 实现支付单创建、结果查询和渠道回调处理。
 * 支付渠道：支付宝（沙箱/正式同一套代码，仅网关与密钥不同）；微信与余额渠道未开放。
 */

@Slf4j
@Service
public class PaymentServiceImpl implements PaymentService {

    @Resource
    private PaymentMapper paymentMapper;

    @Resource
    private OrderInfoMapper orderInfoMapper;

    @Resource
    private OrderService orderService;

    @Resource
    private AlipayClientProvider alipayClientProvider;

    @Resource
    private AlipayProperties alipayProperties;

    /** 模拟支付开关：仅开发/演示环境开启（application.yml pay.mock-enabled），生产必须关闭 */
    @Value("${pay.mock-enabled:false}")
    private boolean mockEnabled;

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
            // 如果存在且未过期，返回已有支付
            if (existingPayment.getCreateTime().plusMinutes(15).isAfter(LocalDateTime.now())) {
                PaymentVO vo = buildPaymentVO(existingPayment);
                fillAlipayPayInfo(vo, existingPayment);
                vo.setExpireTime(System.currentTimeMillis() + PAYMENT_TIMEOUT);
                return vo;
            }

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
        payment.setStatus(0);
        paymentMapper.insert(payment);

        // 4. 调用支付宝沙箱/正式网关，生成收银台地址
        PaymentVO vo = buildPaymentVO(payment);
        fillAlipayPayInfo(vo, payment);
        vo.setExpireTime(System.currentTimeMillis() + PAYMENT_TIMEOUT);
        return vo;
    }

    /**
     * 生成支付宝收银台地址（渠道收敛后唯一渠道）。
     * 复用未过期支付单的路径同样要走这里，保证每次 create 都能拿到支付地址。
     */
    private void fillAlipayPayInfo(PaymentVO vo, Payment payment) {
        vo.setPayUrl(createAlipayOrder(payment));
    }
    /**
     * 查询支付结果。支付宝渠道增加查单补偿：本机无法接收沙箱异步通知（notify_url 需公网）时，
     * 前端轮询本接口会顺带向支付宝主动查单，已支付则按回调同一套逻辑推进订单状态。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public PaymentResultVO queryPaymentResult(String paymentNo) {
        Payment payment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>().eq(Payment::getPaymentNo, paymentNo)
        );

        if (payment == null) {
            throw new BusinessException("支付记录不存在");
        }

        // 查单补偿：支付宝待支付订单主动向渠道确认一次（交易不存在=尚未支付，属正常静默）
        if (payment.getStatus() == PaymentStatus.PENDING
                && alipayClientProvider.isConfigured()) {
            syncAlipayPaymentStatus(payment);
            payment = paymentMapper.selectOne(
                    new LambdaQueryWrapper<Payment>().eq(Payment::getPaymentNo, paymentNo)
            );
        }

        PaymentResultVO vo = new PaymentResultVO();
        BeanUtils.copyProperties(payment, vo);
        return vo;
    }

    /**
     * 主动查单（alipay.trade.query）：沙箱/正式环境交易已支付时，走与回调完全相同的推进逻辑。
     */
    private void syncAlipayPaymentStatus(Payment payment) {
        try {
            AlipayTradeQueryRequest request = new AlipayTradeQueryRequest();
            request.setBizContent("{\"out_trade_no\":\"" + payment.getPaymentNo() + "\"}");
            AlipayTradeQueryResponse response = alipayClientProvider.get().execute(request);
            if (response.isSuccess()) {
                if ("TRADE_SUCCESS".equals(response.getTradeStatus())
                        || "TRADE_FINISHED".equals(response.getTradeStatus())) {
                    log.info("支付宝查单确认已支付，推进订单：paymentNo={}, tradeNo={}", payment.getPaymentNo(), response.getTradeNo());
                    markPaymentSuccess(payment, response.getTradeNo(), "alipay-query-sync");
                }
            } else if ("ACQ.TRADE_NOT_EXIST".equals(response.getSubCode())) {
                // 尚未支付属正常情况，轮询期间频繁出现，降为 debug 避免刷日志
                log.debug("支付宝查单：交易尚不存在（未支付）paymentNo={}", payment.getPaymentNo());
            } else {
                // 其他错误（如验签类问题）需要暴露
                log.warn("支付宝查单未成功：paymentNo={}, code={}, subCode={}, subMsg={}",
                        payment.getPaymentNo(), response.getCode(), response.getSubCode(), response.getSubMsg());
            }
        } catch (AlipayApiException e) {
            // 查询失败（网络等）不阻断查询接口，等待下一次轮询
            log.warn("支付宝查单补偿失败：paymentNo={}, {}", payment.getPaymentNo(), e.getMessage());
        }
    }
    /**
     * 处理支付宝的异步通知（真实回调，验签 + app_id + 金额三重校验）。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void alipayCallback(Map<String, String> params) {
        String paymentNo = params.get("out_trade_no");
        String tradeStatus = params.get("trade_status");

        // 1. 仅处理支付成功通知
        if (paymentNo == null
                || (!"TRADE_SUCCESS".equals(tradeStatus) && !"TRADE_FINISHED".equals(tradeStatus))) {
            return;
        }

        // 2. 验签：用支付宝公钥校验通知的真实性（防伪造回调）
        boolean verified;
        try {
            verified = AlipaySignature.rsaCheckV1(params, alipayProperties.getAlipayPublicKey(),
                    alipayProperties.getCharset(), alipayProperties.getSignType());
        } catch (AlipayApiException e) {
            log.warn("支付宝回调验签异常：paymentNo={}, {}", paymentNo, e.getMessage());
            return;
        }
        if (!verified) {
            log.warn("支付宝回调验签失败，拒绝处理：paymentNo={}", paymentNo);
            return;
        }

        // 3. 归属校验：通知的 app_id 必须是本应用
        if (!alipayProperties.getAppId().equals(params.get("app_id"))) {
            log.warn("支付宝回调 app_id 不匹配：{}", params.get("app_id"));
            return;
        }

        // 4. 幂等 + 金额复核
        Payment payment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>().eq(Payment::getPaymentNo, paymentNo)
        );
        if (payment == null || payment.getStatus() == PaymentStatus.SUCCESS) {
            return; // 防止重复回调
        }
        String notifyAmount = params.get("total_amount");
        if (notifyAmount == null
                || payment.getAmount().compareTo(new BigDecimal(notifyAmount)) != 0) {
            log.warn("支付宝回调金额与支付单不符，拒绝处理：paymentNo={}, notify={}", paymentNo, notifyAmount);
            return;
        }

        // 5. 支付成功推进（与模拟支付共用同一套逻辑）
        markPaymentSuccess(payment, params.get("trade_no"), params.toString());
    }

    /**
     * 模拟支付确认（开发/演示环境）。
     * 校验归属与状态后，复用真实回调的同一套支付成功处理逻辑（幂等推进，盲盒订单同事务抽取）。
     * 开关关闭（生产）时直接拒绝并告警。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void mockPay(Long userId, String paymentNo) {
        if (!mockEnabled) {
            log.warn("模拟支付接口在未开启开关时被调用：paymentNo={}, userId={}", paymentNo, userId);
            throw new BusinessException("模拟支付未开启");
        }
        Payment payment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>().eq(Payment::getPaymentNo, paymentNo)
        );
        if (payment == null) {
            throw new BusinessException("支付记录不存在");
        }
        if (!payment.getUserId().equals(userId)) {
            throw new BusinessException("无权操作该支付");
        }
        if (payment.getStatus() != PaymentStatus.PENDING) {
            throw new BusinessException("该支付单当前状态不可支付");
        }
        markPaymentSuccess(payment, "MOCK" + System.currentTimeMillis(), "mock-pay");
    }

    /**
     * 支付成功统一推进：支付单置已支付 → 订单推进（盲盒订单同事务抽取）。
     * 真实回调与模拟支付共用，保证行为一致。
     */
    private void markPaymentSuccess(Payment payment, String transactionId, String notifyData) {
        payment.setStatus(PaymentStatus.SUCCESS);
        payment.setTransactionId(transactionId);
        payment.setPayTime(LocalDateTime.now());
        payment.setNotifyData(notifyData);
        paymentMapper.updateById(payment);

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
    private PaymentVO buildPaymentVO(Payment payment) {
        PaymentVO vo = new PaymentVO();
        vo.setPaymentNo(payment.getPaymentNo());
        vo.setOrderNo(payment.getOrderNo());
        vo.setAmount(payment.getAmount());
        return vo;
    }

    /**
     * 支付宝下单（alipay.trade.page.pay，电脑网站支付，GET 模式）：
     * 调沙箱网关换取真实收银台地址，前端打开该地址即可用沙箱买家账号完成支付。
     * 异步通知地址仅在配置了 notify-url 时传入；未配内网穿透时依赖查单补偿推进状态。
     */
    private String createAlipayOrder(Payment payment) {
        AlipayClient client = alipayClientProvider.get();
        AlipayTradePagePayRequest request = new AlipayTradePagePayRequest();
        if (alipayProperties.getNotifyUrl() != null && !alipayProperties.getNotifyUrl().isBlank()) {
            request.setNotifyUrl(alipayProperties.getNotifyUrl());
        }
        if (alipayProperties.getReturnUrl() != null && !alipayProperties.getReturnUrl().isBlank()) {
            request.setReturnUrl(alipayProperties.getReturnUrl());
        }
        String totalAmount = payment.getAmount().setScale(2, RoundingMode.HALF_UP).toPlainString();
        request.setBizContent("{" +
                "\"out_trade_no\":\"" + payment.getPaymentNo() + "\"," +
                "\"total_amount\":\"" + totalAmount + "\"," +
                "\"subject\":\"PP音乐订单-" + payment.getOrderNo() + "\"," +
                "\"product_code\":\"FAST_INSTANT_TRADE_PAY\"" +
                "}");
        try {
            AlipayTradePagePayResponse response = client.pageExecute(request, "GET");
            if (!response.isSuccess()) {
                throw new BusinessException("支付宝下单失败：" + response.getSubMsg());
            }
            log.info("支付宝下单成功：paymentNo={}, 金额={}", payment.getPaymentNo(), totalAmount);
            return response.getBody();
        } catch (AlipayApiException e) {
            log.error("支付宝下单异常：paymentNo={}", payment.getPaymentNo(), e);
            throw new BusinessException("支付宝下单异常：" + e.getMessage());
        }
    }
}