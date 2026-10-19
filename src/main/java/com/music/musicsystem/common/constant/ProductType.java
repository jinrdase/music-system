package com.music.musicsystem.common.constant;

/**
 * 定义专辑商品的实物与数字内容形态。
 */

public final class ProductType {
    public static final String PHYSICAL = "PHYSICAL";
    public static final String DIGITAL = "DIGITAL";

    private ProductType() {
    }
    /**
     * 判断当前商品形态是否为实物。
     */

    public static boolean isPhysical(String value) {
        return PHYSICAL.equalsIgnoreCase(value);
    }
    /**
     * 判断当前商品形态是否为数字内容。
     */

    public static boolean isDigital(String value) {
        return DIGITAL.equalsIgnoreCase(value);
    }
}