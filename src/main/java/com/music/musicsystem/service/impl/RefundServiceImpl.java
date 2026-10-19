package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import tools.jackson.core.JacksonException;
import tools.jackson.core.type.TypeReference;
import tools.jackson.databind.ObjectMapper;
import com.music.musicsystem.common.constant.OrderStatus;
import com.music.musicsystem.common.constant.ProductType;
import com.music.musicsystem.common.constant.RefundPolicy;
import com.music.musicsystem.common.constant.RefundStatus;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.dto.RefundDTO;
import com.music.musicsystem.dto.RefundReviewDTO;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.entity.RefundApplication;
import com.music.musicsystem.mapper.OrderInfoMapper;
import com.music.musicsystem.mapper.RefundApplicationMapper;
import com.music.musicsystem.service.RefundService;
import com.music.musicsystem.vo.RefundApplicationVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 实现退款申请、审核及订单退款处理。
 */

@Service
public class RefundServiceImpl implements RefundService {

    private final OrderInfoMapper orderInfoMapper;
    private final RefundApplicationMapper refundApplicationMapper;
    private final ObjectMapper objectMapper;

    public RefundServiceImpl(OrderInfoMapper orderInfoMapper,
                             RefundApplicationMapper refundApplicationMapper,
                             ObjectMapper objectMapper) {
        this.orderInfoMapper = orderInfoMapper;
        this.refundApplicationMapper = refundApplicationMapper;
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
     * 审核退款申请并执行相应退款处理。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void review(Long applicationId, Long auditorId, RefundReviewDTO dto) {
        int newStatus = Boolean.TRUE.equals(dto.getApproved())
                ? RefundStatus.APPROVED : RefundStatus.REJECTED;
        int updated = refundApplicationMapper.update(
                null,
                new LambdaUpdateWrapper<RefundApplication>()
                        .eq(RefundApplication::getId, applicationId)
                        .eq(RefundApplication::getStatus, RefundStatus.PENDING)
                        .set(RefundApplication::getStatus, newStatus)
                        .set(RefundApplication::getAuditRemark, dto.getAuditRemark())
                        .set(RefundApplication::getAuditorId, auditorId)
                        .set(RefundApplication::getAuditTime, LocalDateTime.now())
        );
        if (updated == 0) {
            throw new BusinessException("退款申请不存在或已审核");
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