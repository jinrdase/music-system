package com.music.musicsystem.config;

import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.music.musicsystem.common.exception.BusinessException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * 懒加载支付宝客户端：私钥未配置时应用照常启动，
 * 仅在真正调用支付宝接口时才报"未配置"，保证模拟支付路径不受影响。
 */
@Component
@RequiredArgsConstructor
public class AlipayClientProvider {

    private final AlipayProperties properties;

    private volatile AlipayClient client;

    /** 是否已完成支付宝配置（应用私钥存在） */
    public boolean isConfigured() {
        return properties.getAppPrivateKey() != null && !properties.getAppPrivateKey().isBlank();
    }

    /** 获取支付宝客户端；未配置私钥时抛业务异常 */
    public AlipayClient get() {
        if (!isConfigured()) {
            throw new BusinessException("支付宝沙箱未配置应用私钥（alipay-local.properties 或环境变量 ALIPAY_APP_PRIVATE_KEY）");
        }
        if (client == null) {
            synchronized (this) {
                if (client == null) {
                    client = new DefaultAlipayClient(
                            properties.getGateway(),
                            properties.getAppId(),
                            properties.getAppPrivateKey(),
                            properties.getFormat(),
                            properties.getCharset(),
                            properties.getAlipayPublicKey(),
                            properties.getSignType());
                }
            }
        }
        return client;
    }
}
