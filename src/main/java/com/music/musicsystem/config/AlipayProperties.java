package com.music.musicsystem.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 支付宝接入配置（沙箱/正式共用了同一组键，换环境只改配置值）。
 */
@Data
@Component
@ConfigurationProperties(prefix = "alipay")
public class AlipayProperties {

    /** 网关地址：沙箱 https://openapi-sandbox.dl.alipaydev.com/gateway.do */
    private String gateway;

    /** 开放平台分配的 APPID */
    private String appId;

    /** 应用私钥（PKCS8），用于请求签名；来自 alipay-local.properties 或环境变量 */
    private String appPrivateKey;

    /** 支付宝公钥，用于回调验签（非机密） */
    private String alipayPublicKey;

    /** 签名类型 */
    private String signType = "RSA2";

    /** 异步通知地址（需公网可达；留空则依赖查单补偿推进状态） */
    private String notifyUrl;

    /** 支付成功后浏览器跳回的前端地址（可选） */
    private String returnUrl;

    private String format = "json";

    private String charset = "UTF-8";
}
