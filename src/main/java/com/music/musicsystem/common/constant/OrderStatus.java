package com.music.musicsystem.common.constant;

/**
 * 定义业务状态或类型及其判断规则。
 */
public class OrderStatus {
    /** 未支付 */
    public static final Integer UNPAID = 0;

    /** 已支付 */
    public static final Integer PAID = 1;

    /** 已完成 */
    public static final Integer COMPLETED = 2;

    /** 已取消 */
    public static final Integer CANCELLED = 3;

    /** 已发货 */
    public static final Integer SHIPPED = 4;

    /** 已退款（退款申请审核通过后的订单终态） */
    public static final Integer REFUNDED = 5;

    /**
     * 状态值转展示文案（唯一口径，见需求文档 5.3 状态映射表）。
     */
    public static String toText(Integer status) {
        if (status == null) {
            return "未知";
        }
        return switch (status) {
            case 0 -> "待支付";
            case 1 -> "已支付";
            case 2 -> "已完成";
            case 3 -> "已取消";
            case 4 -> "已发货";
            case 5 -> "已退款";
            default -> "未知";
        };
    }
}