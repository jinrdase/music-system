package com.music.musicsystem.common.constant;

import com.music.musicsystem.entity.OrderInfo;

/**
 * 集中判断商品退款条件及退货要求。
 */

public final class RefundPolicy {
    private RefundPolicy() {
    }
    /**
     * 判断指定商品及状态是否允许申请退款。
     */

    public static boolean canApply(OrderInfo order) {
        if (order == null) return false;
        if (ProductType.isPhysical(order.getProductType())) {
            return OrderStatus.PAID.equals(order.getStatus()) || OrderStatus.SHIPPED.equals(order.getStatus());
        }
        return ProductType.isDigital(order.getProductType())
                && OrderStatus.PAID.equals(order.getStatus())
                && order.getDigitalContentAccessedAt() == null;
    }
    /**
     * 判断退款是否需要退回实物商品。
     */

    public static boolean requiresReturnShipping(OrderInfo order) {
        return order != null && ProductType.isPhysical(order.getProductType())
                && OrderStatus.SHIPPED.equals(order.getStatus());
    }
}