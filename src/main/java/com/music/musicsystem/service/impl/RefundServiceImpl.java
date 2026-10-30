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
     */
    private void approveAndExecuteRefund(Long applicationId, Long auditorId, RefundReviewDTO dto) {
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
        RefundApplication application = refundApplicationMapper.selectById(applicationId);

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
            callAlipayRefund(payment, application);
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
     * 真实支付宝支付判断：交易号非模拟支付生成的 MOCK 前缀。
     * 模拟支付/回调走的支付没有渠道侧资金，退款只做本地状态流转。
     */
    private boolean isRealAlipayPayment(Payment payment) {
        return payment.getTransactionId() != null
                && !payment.getTransactionId().startsWith("MOCK");
    }

    /**
     * 调用支付宝退款接口（alipay.trade.refund，同步返回）。
     * 退款单号按 applicationId 确定性生成：同一申请重试生成同一单号，渠道侧天然幂等。
     */
    private void callAlipayRefund(Payment payment, RefundApplication application) {
        AlipayClient client = alipayClientProvider.get();
        AlipayTradeRefundRequest request = new AlipayTradeRefundRequest();
        String refundAmount = application.getRefundAmount().setScale(2, java.math.RoundingMode.HALF_UP).toPlainString();
        request.setBizContent("{" +
                "\"out_trade_no\":\"" + payment.getPaymentNo() + "\"," +
                "\"refund_amount\":\"" + refundAmount + "\"," +
                "\"out_request_no\":\"R" + application.getId() + "\"," +
                "\"refund_reason\":\"user refund\"" +
                "}");
        try {
            AlipayTradeRefundResponse response = client.execute(request);
            if (!response.isSuccess()) {
                throw new BusinessException("支付宝退款失败：" + response.getSubMsg());
            }
            log.info("支付宝退款成功：申请ID={}, paymentNo={}, 金额={}, fundChange={}",
                    application.getId(), payment.getPaymentNo(), refundAmount, response.getFundChange());
        } catch (AlipayApiException e) {
            log.error("支付宝退款异常：申请ID={}", application.getId(), e);
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