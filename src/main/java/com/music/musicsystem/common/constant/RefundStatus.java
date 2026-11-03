package com.music.musicsystem.common.constant;

/**
 * 定义退款申请的状态值。
 */

public final class RefundStatus {
    public static final int PENDING = 0;
    public static final int APPROVED = 1;
    public static final int REJECTED = 2;
    public static final int REFUNDED = 3;

    private RefundStatus() {
    }

    /**
     * 状态值转展示文案。
     */
    public static String toText(Integer status) {
        if (status == null) {
            return "";
        }
        return switch (status) {
            case PENDING -> "审核中";
            case APPROVED -> "已通过";
            case REJECTED -> "已驳回";
            case REFUNDED -> "已退款";
            default -> "未知";
        };
    }
}