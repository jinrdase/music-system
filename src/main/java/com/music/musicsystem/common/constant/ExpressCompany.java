package com.music.musicsystem.common.constant;

/**
 * 承运商映射：order_logistics.carrier（发货下拉框的固定中文值）→ 快递100 公司编码。
 * 编码来源：快递100 开放平台编码表（顺丰 shunfeng、极兔 jtexpress，实现时已对照官方文档）。
 */
public enum ExpressCompany {

    SF("顺丰速运", "shunfeng", true),
    ZTO("中通快递", "zhongtong", false),
    YTO("圆通速递", "yuantong", false),
    YUNDA("韵达快递", "yunda", false),
    STO("申通快递", "shentong", false),
    JTEXPRESS("极兔速递", "jtexpress", false),
    JD("京东物流", "jd", true),
    EMS("邮政EMS", "ems", false);

    /** order_logistics.carrier 存储的中文名（与后台发货下拉框一致） */
    private final String carrierName;

    /** 快递100 公司编码 */
    private final String kuaidi100Code;

    /** 该承运商是否必须传收/寄件人手机号后四位（顺丰、京东） */
    private final boolean phoneRequired;

    ExpressCompany(String carrierName, String kuaidi100Code, boolean phoneRequired) {
        this.carrierName = carrierName;
        this.kuaidi100Code = kuaidi100Code;
        this.phoneRequired = phoneRequired;
    }

    public String getCarrierName() {
        return carrierName;
    }

    public String getKuaidi100Code() {
        return kuaidi100Code;
    }

    public boolean isPhoneRequired() {
        return phoneRequired;
    }

    /**
     * 按承运商名匹配，兼容用户侧可能存在的自由文本（包含匹配，如"顺丰"命中"顺丰速运"）。
     */
    public static ExpressCompany fromCarrierName(String carrierName) {
        if (carrierName == null || carrierName.isBlank()) {
            return null;
        }
        String name = carrierName.trim();
        for (ExpressCompany company : values()) {
            if (company.carrierName.equals(name)) {
                return company;
            }
        }
        for (ExpressCompany company : values()) {
            if (name.contains(company.carrierName) || company.carrierName.contains(name)) {
                return company;
            }
        }
        return null;
    }
}
