package com.music.musicsystem.common.constant;

import com.music.musicsystem.entity.OrderInfo;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

class RefundPolicyTest {
    @Test
    void physicalOrdersCanBeRefundedBeforeCompletionAndShippedOrdersNeedReturnDetails() {
        OrderInfo order = order("PHYSICAL", OrderStatus.PAID);
        assertTrue(RefundPolicy.canApply(order));
        assertFalse(RefundPolicy.requiresReturnShipping(order));
        order.setStatus(OrderStatus.SHIPPED);
        assertTrue(RefundPolicy.canApply(order));
        assertTrue(RefundPolicy.requiresReturnShipping(order));
        order.setStatus(OrderStatus.COMPLETED);
        assertFalse(RefundPolicy.canApply(order));
    }

    @Test
    void digitalOrdersCanBeRefundedOnlyBeforeDelivery() {
        OrderInfo order = order("DIGITAL", OrderStatus.PAID);
        assertTrue(RefundPolicy.canApply(order));
        order.setDigitalContentAccessedAt(LocalDateTime.now());
        assertFalse(RefundPolicy.canApply(order));
        order.setDigitalContentAccessedAt(null);
        order.setStatus(OrderStatus.SHIPPED);
        assertFalse(RefundPolicy.canApply(order));
    }

    private OrderInfo order(String type, Integer status) {
        OrderInfo order = new OrderInfo();
        order.setProductType(type);
        order.setStatus(status);
        return order;
    }
}
