package com.music.musicsystem.common.constant;

/**
 * 定义支付单的状态值（唯一口径）。
 */
public final class PaymentStatus {
    /** 待支付 */
    public static final int PENDING = 0;
    /** 支付成功 */
    public static final int SUCCESS = 1;
    /** 支付失败/已关闭 */
    public static final int FAILED = 2;
    /** 已退款 */
    public static final int REFUNDED = 3;

    private PaymentStatus() {
    }
}
