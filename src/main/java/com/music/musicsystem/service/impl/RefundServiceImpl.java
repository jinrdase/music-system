package com.music.musicsystem.service.impl;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.request.AlipayTradeRefundRequest;
import com.alipay.api.response.AlipayTradeRefundResponse;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import tools.jackson.core.JacksonException;
import tools.jackson.core.type.TypeReference;
import tools.jackson.databind.ObjectMapper;
import com.music.musicsystem.common.constant.OrderStatus;
import com.music.musicsystem.common.constant.PaymentStatus;
import com.music.musicsystem.common.constant.ProductType;
import com.music.musicsystem.common.constant.RefundPolicy;
import com.music.musicsystem.common.constant.RefundStatus;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.config.AlipayClientProvider;
import com.music.musicsystem.config.AlipayProperties;
import com.music.musicsystem.dto.RefundDTO;
import com.music.musicsystem.dto.RefundReviewDTO;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.entity.OrderItem;
import com.music.musicsystem.entity.Payment;
import com.music.musicsystem.entity.RefundApplication;
import com.music.musicsystem.mapper.OrderInfoMapper;
import com.music.musicsystem.mapper.OrderItemMapper;
import com.music.musicsystem.mapper.PaymentMapper;
import com.music.musicsystem.mapper.RefundApplicationMapper;
import com.music.musicsystem.service.OrderService;
import com.music.musicsystem.service.RefundService;
import com.music.musicsystem.vo.RefundApplicationVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 实现退款申请、审核及订单退款处理。
 */

@Slf4j
@Service
public class RefundServiceImpl implements RefundService {

    private final OrderInfoMapper orderInfoMapper;
    private final RefundApplicationMapper refundApplicationMapper;
    private final PaymentMapper paymentMapper;
    private final OrderService orderService;
    private final OrderItemMapper orderItemMapper;
    private final AlipayClientProvider alipayClientProvider;
    private final ObjectMapper objectMapper;

    public RefundServiceImpl(OrderInfoMapper orderInfoMapper,
                             RefundApplicationMapper refundApplicationMapper,
                             PaymentMapper paymentMapper,
                             OrderService orderService,
                             OrderItemMapper orderItemMapper,
                             AlipayClientProvider alipayClientProvider,
                             ObjectMapper objectMapper) {
        this.orderInfoMapper = orderInfoMapper;
        this.refundApplicationMapper = refundApplicationMapper;
        this.paymentMapper = paymentMapper;
        this.orderService = orderService;
        this.orderItemMapper = orderItemMapper;
        this.alipayClientProvider = alipayClientProvider;
        this.objectMapper = objectMapper;
    }
    /**
     * 提交退款申请并校验订单是否符合退款条件。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RefundApplicationVO apply(Long userId, RefundDTO dto) {
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getId, dto.getOrderId())
                        .eq(OrderInfo::getUserId, userId)
                        .last("FOR UPDATE")
        );
        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        if (!RefundPolicy.canApply(order)) {
            throw new BusinessException("只有已支付且未确认收货的订单可以申请退款");
        }
        // 审查 G-2：盲盒订单支付即抽取（抽取结果摘要回写订单），已抽取订单退款会形成
        // “白拿奖品+全额退款”套利，直接拒绝
        if (order.getOrderType() != null && order.getOrderType() == 2
                && order.getDrawSummary() != null) {
            throw new BusinessException("盲盒订单已抽取，不支持退款");
        }
        if (ProductType.isDigital(order.getProductType()) && order.getDigitalContentAccessedAt() != null) {
            throw new BusinessException("数字内容已交付，不能在线提交退款申请");
        }
        // 明细级退款闸门（多明细订单）：任一数字明细已取阅即整单不可退
        Long accessedDigitalItems = orderItemMapper.selectCount(
                new LambdaQueryWrapper<OrderItem>()
                        .eq(OrderItem::getOrderId, order.getId())
                        .eq(OrderItem::getProductType, ProductType.DIGITAL)
                        .isNotNull(OrderItem::getDigitalContentAccessedAt)
        );
        if (accessedDigitalItems != null && accessedDigitalItems > 0) {
            throw new BusinessException("订单中数字内容已交付，不能在线提交退款申请");
        }
        if (RefundPolicy.requiresReturnShipping(order)
                && (isBlank(dto.getReturnCarrier()) || isBlank(dto.getReturnTrackingNo()))) {
            throw new BusinessException("已发货订单申请退款时必须填写退货物流公司和物流单号");
        }

        Long existing = refundApplicationMapper.selectCount(
                new LambdaQueryWrapper<RefundApplication>()
                        .eq(RefundApplication::getOrderId, order.getId())
                        .in(RefundApplication::getStatus, RefundStatus.PENDING, RefundStatus.APPROVED,
                                RefundStatus.REFUNDED)
        );
        if (existing != null && existing > 0) {
            throw new BusinessException("该订单已有待处理或已通过的退款申请");
        }

        RefundApplication application = new RefundApplication();
        application.setOrderId(order.getId());
        application.setOrderNo(order.getOrderNo());
        application.setUserId(userId);
        application.setRefundAmount(order.getTotalAmount());
        application.setReason(dto.getReason().trim());
        application.setDescription(dto.getDescription());
        application.setReturnCarrier(trimToNull(dto.getReturnCarrier()));
        application.setReturnTrackingNo(trimToNull(dto.getReturnTrackingNo()));
        application.setStatus(RefundStatus.PENDING);
        application.setDeleted(0);
        if (dto.getImages() != null && !dto.getImages().isEmpty()) {
            try {
                application.setImages(objectMapper.writeValueAsString(dto.getImages()));
            } catch (JacksonException e) {
                throw new BusinessException("退款凭证格式无效");
            }
        }
        refundApplicationMapper.insert(application);
        return toVO(application);
    }
    /**
     * 查询当前用户提交的退款申请。
     */

    @Override
    public Page<RefundApplicationVO> getMyApplications(Long userId, Integer current, Integer size) {
        Page<RefundApplication> page = refundApplicationMapper.selectPage(
                new Page<>(current, size),
                new LambdaQueryWrapper<RefundApplication>()
                        .eq(RefundApplication::getUserId, userId)
                        .orderByDesc(RefundApplication::getCreateTime)
        );
        return toVOPage(page);
    }
    /**
     * 分页查询待审核的退款申请。
     */

    @Override
    public Page<RefundApplicationVO> getPendingApplications(Integer current, Integer size) {
        Page<RefundApplication> page = refundApplicationMapper.selectPage(
                new Page<>(current, size),
                new LambdaQueryWrapper<RefundApplication>()
                        .eq(RefundApplication::getStatus, RefundStatus.PENDING)
                        .orderByAsc(RefundApplication::getCreateTime)
        );
        return toVOPage(page);
    }
    /**
     * 审核退款申请。
     * 拒绝：仅将申请置为已拒绝，不触碰订单/支付/库存；用户可重新提交。
     * 通过：同一事务内执行退款（一刀切策略）——申请置已退款(3)、订单置已退款(5)、
     * 支付单置已退款(3)、按下单数量回补库存并写库存流水(type=2)。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void review(Long applicationId, Long auditorId, RefundReviewDTO dto) {
        if (Boolean.TRUE.equals(dto.getApproved())) {
            approveAndExecuteRefund(applicationId, auditorId, dto);
            return;
        }

        // 与接口文档一致：拒绝必须填写原因
        if (dto.getAuditRemark() == null || dto.getAuditRemark().isBlank()) {
            throw new BusinessException("拒绝退款申请时必须填写审核备注");
        }

        int updated = refundApplicationMapper.update(
                null,
                new LambdaUpdateWrapper<RefundApplication>()
                        .eq(RefundApplication::getId, applicationId)
                        .eq(RefundApplication::getStatus, RefundStatus.PENDING)
                        .set(RefundApplication::getStatus, RefundStatus.REJECTED)
                        .set(RefundApplication::getAuditRemark, dto.getAuditRemark())
                        .set(RefundApplication::getAuditorId, auditorId)
                        .set(RefundApplication::getAuditTime, LocalDateTime.now())
        );
        if (updated == 0) {
            throw new BusinessException("退款申请不存在或已审核");
        }
    }

    /**
     * 审核通过并执行退款。全链路状态推进都使用条件更新，任一步失败抛异常回滚整个事务，
     * 申请回到待审核状态，不会出现"申请已通过但订单未退款"的中间态。
     * 执行前复核全部退款条件（审查 G-3）：申请后、审核前数字内容可能已被取阅、
     * 盲盒可能已抽取、订单状态可能已变化——不满足则自动拒绝申请而非照常退款。
     */
    private void approveAndExecuteRefund(Long applicationId, Long auditorId, RefundReviewDTO dto) {
        RefundApplication application = refundApplicationMapper.selectById(applicationId);
        if (application == null || application.getStatus() != RefundStatus.PENDING) {
            throw new BusinessException("该申请已被处理，请刷新列表");
        }

        // 0. 复核退款条件（订单行 FOR UPDATE，与确认收货/数字取阅串行化，审查 G-3/M-7）
        OrderInfo lockedOrder = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getId, application.getOrderId())
                        .last("FOR UPDATE")
        );
        if (lockedOrder == null) {
            throw new BusinessException("订单不存在");
        }
        String rejectReason = checkRefundStillValid(lockedOrder);
        if (rejectReason != null) {
            // 自动拒绝后正常返回（不能抛异常，否则整个事务回滚、拒绝状态落不了库），
            // 管理端列表会显示“已拒绝 + 复核不通过原因”
            int rejected = refundApplicationMapper.update(
                    null,
                    new LambdaUpdateWrapper<RefundApplication>()
                            .eq(RefundApplication::getId, applicationId)
                            .eq(RefundApplication::getStatus, RefundStatus.PENDING)
                            .set(RefundApplication::getStatus, RefundStatus.REJECTED)
                            .set(RefundApplication::getAuditRemark, "复核不通过：" + rejectReason)
                            .set(RefundApplication::getAuditorId, auditorId)
                            .set(RefundApplication::getAuditTime, LocalDateTime.now())
            );
            if (rejected > 0) {
                log.info("退款申请复核不通过，自动拒绝：申请ID={}, 原因={}", applicationId, rejectReason);
                return;
            }
            throw new BusinessException("该申请已被处理，请刷新列表");
        }

        // 1. 条件更新申请状态（WHERE status=0），并发审核仅一处成功
        int updated = refundApplicationMapper.update(
                null,
                new LambdaUpdateWrapper<RefundApplication>()
                        .eq(RefundApplication::getId, applicationId)
                        .eq(RefundApplication::getStatus, RefundStatus.PENDING)
                        .set(RefundApplication::getStatus, RefundStatus.REFUNDED)
                        .set(RefundApplication::getAuditRemark, dto.getAuditRemark())
                        .set(RefundApplication::getAuditorId, auditorId)
                        .set(RefundApplication::getAuditTime, LocalDateTime.now())
        );
        if (updated == 0) {
            throw new BusinessException("该申请已被处理，请刷新列表");
        }

        // 2. 订单推进为已退款(5)：仅已支付/已发货可退（条件更新防并发）
        int orderUpdated = orderInfoMapper.update(
                null,
                new LambdaUpdateWrapper<OrderInfo>()
                        .eq(OrderInfo::getId, application.getOrderId())
                        .in(OrderInfo::getStatus, OrderStatus.PAID, OrderStatus.SHIPPED)
                        .set(OrderInfo::getStatus, OrderStatus.REFUNDED)
        );
        if (orderUpdated == 0) {
            throw new BusinessException("订单当前状态不支持退款（仅已支付/已发货订单可退）");
        }
        OrderInfo order = orderInfoMapper.selectById(application.getOrderId());

        // 3. 找到已支付支付单；真实支付宝支付先调渠道退款（失败抛异常整体回滚，申请保持待审核）
        Payment payment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>()
                        .eq(Payment::getOrderId, order.getId())
                        .eq(Payment::getStatus, PaymentStatus.SUCCESS)
        );
        if (payment == null) {
            throw new BusinessException("未找到已支付的支付单，退款执行失败");
        }
        if (isRealAlipayPayment(payment)) {
            callAlipayRefund(payment, application.getRefundAmount(),
                    "R" + application.getId(), "用户退款审核通过");
        }

        // 4. 支付单置为已退款(3)
        int paymentUpdated = paymentMapper.update(
                null,
                new LambdaUpdateWrapper<Payment>()
                        .eq(Payment::getId, payment.getId())
                        .eq(Payment::getStatus, PaymentStatus.SUCCESS)
                        .set(Payment::getStatus, PaymentStatus.REFUNDED)
        );
        if (paymentUpdated == 0) {
            throw new BusinessException("未找到已支付的支付单，退款执行失败");
        }

        // 5. 按下单数量回补库存并写库存流水(type=2)，复用取消/超时的恢复逻辑
        orderService.restoreStock(order);
        log.info("退款执行完成：申请ID={}, 订单号={}, 退款金额={}",
                applicationId, order.getOrderNo(), application.getRefundAmount());
    }

    /**
     * 退款执行前的条件复核（与 apply() 同一套闸门）：返回拒绝原因，null 表示可退。
     */
    private String checkRefundStillValid(OrderInfo order) {
        if (!RefundPolicy.canApply(order)) {
            return "订单当前状态不支持退款";
        }
        if (ProductType.isDigital(order.getProductType()) && order.getDigitalContentAccessedAt() != null) {
            return "数字内容已取阅";
        }
        Long accessedDigitalItems = orderItemMapper.selectCount(
                new LambdaQueryWrapper<OrderItem>()
                        .eq(OrderItem::getOrderId, order.getId())
                        .eq(OrderItem::getProductType, ProductType.DIGITAL)
                        .isNotNull(OrderItem::getDigitalContentAccessedAt)
        );
        if (accessedDigitalItems != null && accessedDigitalItems > 0) {
            return "订单中数字内容已取阅";
        }
        if (order.getOrderType() != null && order.getOrderType() == 2
                && order.getDrawSummary() != null) {
            return "盲盒订单已抽取";
        }
        return null;
    }

    /**
     * 系统自动退款（审查 G-1/M-8 资金补偿）：真实支付宝支付先调渠道退款
     * （out_request_no 按 SYS+订单ID 确定性生成，重试天然幂等），
     * 支付单条件更新置已退款，并落一条系统退款记录供对账。订单状态与库存由调用方处理。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void executeSystemRefund(OrderInfo order, String reason) {
        Payment payment = paymentMapper.selectOne(
                new LambdaQueryWrapper<Payment>()
                        .eq(Payment::getOrderId, order.getId())
                        .eq(Payment::getStatus, PaymentStatus.SUCCESS)
                        .orderByDesc(Payment::getId)
                        .last("LIMIT 1")
        );
        if (payment == null) {
            log.warn("系统退款未找到已支付支付单，跳过支付单处理：订单号={}", order.getOrderNo());
        } else {
            if (isRealAlipayPayment(payment)) {
                callAlipayRefund(payment, order.getTotalAmount(),
                        "SYS" + order.getId(), reason);
            }
            int paymentUpdated = paymentMapper.update(
                    null,
                    new LambdaUpdateWrapper<Payment>()
                            .eq(Payment::getId, payment.getId())
                            .eq(Payment::getStatus, PaymentStatus.SUCCESS)
                            .set(Payment::getStatus, PaymentStatus.REFUNDED)
            );
            if (paymentUpdated == 0) {
                log.warn("系统退款：支付单 {} 状态已变化，未重复置为已退款", payment.getPaymentNo());
            }
        }

        RefundApplication application = new RefundApplication();
        application.setOrderId(order.getId());
        application.setOrderNo(order.getOrderNo());
        application.setUserId(order.getUserId());
        application.setRefundAmount(order.getTotalAmount());
        application.setReason(reason);
        application.setStatus(RefundStatus.REFUNDED);
        application.setAuditRemark("系统自动退款：" + reason);
        application.setDeleted(0);
        refundApplicationMapper.insert(application);
        log.info("系统自动退款完成：订单号={}, 金额={}", order.getOrderNo(), order.getTotalAmount());
    }

    /**
     * 真实支付宝支付判断：交易号非模拟支付生成的 MOCK 前缀。
     * 模拟支付/回调走的支付没有渠道侧资金，退款只做本地状态流转。
     */
    private boolean isRealAlipayPayment(Payment payment) {
        return payment.getTransactionId() != null
                && !payment.getTransactionId().startsWith("MOCK");
    }

    /**
     * 调用支付宝退款接口（alipay.trade.refund，同步返回）。
     * out_request_no 由调用方确定性生成（审核退款=R+申请ID、系统退款=SYS+订单ID）：
     * 同一业务重试生成同一单号，渠道侧天然幂等。
     * fund_change=N 说明渠道侧本请求未动账——只会出现在同单号重试场景
     * （此前请求已实际退款，本地事务回滚后的重试），资金已在更早一次离账，视为成功（审查 L-6）。
     */
    private void callAlipayRefund(Payment payment, BigDecimal refundAmount,
                                  String outRequestNo, String refundReason) {
        AlipayClient client = alipayClientProvider.get();
        AlipayTradeRefundRequest request = new AlipayTradeRefundRequest();
        String amount = refundAmount.setScale(2, java.math.RoundingMode.HALF_UP).toPlainString();
        request.setBizContent("{" +
                "\"out_trade_no\":\"" + payment.getPaymentNo() + "\"," +
                "\"refund_amount\":\"" + amount + "\"," +
                "\"out_request_no\":\"" + outRequestNo + "\"," +
                "\"refund_reason\":\"" + refundReason + "\"" +
                "}");
        try {
            AlipayTradeRefundResponse response = client.execute(request);
            if (!response.isSuccess()) {
                throw new BusinessException("支付宝退款失败：" + response.getSubMsg());
            }
            if (!"Y".equals(response.getFundChange())) {
                log.warn("支付宝退款 fund_change=N（同单号重试，资金此前已退）：paymentNo={}, outRequestNo={}",
                        payment.getPaymentNo(), outRequestNo);
            }
            log.info("支付宝退款成功：paymentNo={}, outRequestNo={}, 金额={}",
                    payment.getPaymentNo(), outRequestNo, amount);
        } catch (AlipayApiException e) {
            log.error("支付宝退款异常：paymentNo={}, outRequestNo={}", payment.getPaymentNo(), outRequestNo, e);
            throw new BusinessException("支付宝退款异常：" + e.getMessage());
        }
    }

    private Page<RefundApplicationVO> toVOPage(Page<RefundApplication> page) {
        Page<RefundApplicationVO> result = new Page<>(page.getCurrent(), page.getSize(), page.getTotal());
        result.setRecords(page.getRecords().stream().map(this::toVO).toList());
        return result;
    }

    private RefundApplicationVO toVO(RefundApplication application) {
        RefundApplicationVO vo = new RefundApplicationVO();
        BeanUtils.copyProperties(application, vo);
        if (application.getImages() != null && !application.getImages().isBlank()) {
            try {
                vo.setImages(objectMapper.readValue(application.getImages(), new TypeReference<List<String>>() {}));
            } catch (JacksonException e) {
                throw new BusinessException("退款凭证数据格式无效");
            }
        }
        return vo;
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private String trimToNull(String value) {
        return isBlank(value) ? null : value.trim();
    }
}