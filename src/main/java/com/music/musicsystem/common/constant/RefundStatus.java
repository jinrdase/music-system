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
}