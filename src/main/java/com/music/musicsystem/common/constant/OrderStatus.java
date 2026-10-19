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
}