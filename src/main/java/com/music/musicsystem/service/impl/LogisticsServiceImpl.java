package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.music.musicsystem.common.constant.ExpressCompany;
import com.music.musicsystem.common.constant.OrderStatus;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.config.LogisticsProperties;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.entity.OrderLogistics;
import com.music.musicsystem.mapper.OrderLogisticsMapper;
import com.music.musicsystem.mapper.OrderInfoMapper;
import com.music.musicsystem.service.LogisticsService;
import com.music.musicsystem.vo.LogisticsTrackVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 物流轨迹查询：快递100 免费版（poll/query.do）+ Redis 缓存 + 降级。
 * <p>
 * 未配置授权时降级为仅返回承运商与单号（trackEnabled=false），不报错；
 * 顺丰/京东按快递100 要求附带收件人手机号后四位（从订单收货信息取，用户无感）。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LogisticsServiceImpl implements LogisticsService {

    private static final String CACHE_KEY_PREFIX = "logistics:track:";

    /** 轨迹缓存序列化用 Jackson 3（原生支持 java.time；Jackson 2 无 jsr310 模块会抛 InvalidDefinitionException，
     * 且 Boot 4 类路径上没有 Jackson 2 的 ObjectMapper Bean——与 MusicTools 同因） */
    private static final tools.jackson.databind.ObjectMapper OBJECT_MAPPER =
            tools.jackson.databind.json.JsonMapper.builder().build();

    private final OrderInfoMapper orderInfoMapper;
    private final OrderLogisticsMapper orderLogisticsMapper;
    private final StringRedisTemplate redisTemplate;
    private final LogisticsProperties logisticsProperties;
    private final RestClient.Builder restClientBuilder;

    @Override
    public LogisticsTrackVO getTrack(Long userId, String orderNo) {
        OrderInfo order = orderInfoMapper.selectOne(new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getOrderNo, orderNo)
                .eq(OrderInfo::getUserId, userId));
        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        if (!OrderStatus.SHIPPED.equals(order.getStatus()) && !OrderStatus.COMPLETED.equals(order.getStatus())) {
            throw new BusinessException("该订单尚未发货，暂无物流信息");
        }

        OrderLogistics logistics = orderLogisticsMapper.selectOne(new LambdaQueryWrapper<OrderLogistics>()
                .eq(OrderLogistics::getOrderId, order.getId()));
        if (logistics == null) {
            throw new BusinessException("该订单尚未登记物流信息");
        }

        LogisticsTrackVO vo = new LogisticsTrackVO();
        vo.setOrderNo(orderNo);
        vo.setCarrier(logistics.getCarrier());
        vo.setTrackingNo(logistics.getTrackingNo());
        vo.setShippedAt(logistics.getShippedAt());

        if (!logisticsProperties.isEnabled()
                || logisticsProperties.getKey() == null || logisticsProperties.getKey().isBlank()
                || logisticsProperties.getCustomer() == null || logisticsProperties.getCustomer().isBlank()) {
            vo.setTrackEnabled(false);
            return vo;
        }
        vo.setTrackEnabled(true);

        String cacheKey = CACHE_KEY_PREFIX + orderNo;
        LogisticsTrackVO cached = readCache(cacheKey);
        if (cached != null) {
            return cached;
        }

        ExpressCompany company = ExpressCompany.fromCarrierName(logistics.getCarrier());
        if (company == null) {
            throw new BusinessException("暂不支持该承运商的轨迹查询，可复制单号到快递官网查询");
        }
        queryKuaidi100(vo, company, order, logistics);
        writeCache(cacheKey, vo);
        return vo;
    }

    private void queryKuaidi100(LogisticsTrackVO vo, ExpressCompany company, OrderInfo order, OrderLogistics logistics) {
        Map<String, Object> param = new LinkedHashMap<>();
        param.put("com", company.getKuaidi100Code());
        param.put("num", logistics.getTrackingNo());
        param.put("resultv2", "6");
        if (company.isPhoneRequired()) {
            String phone = order.getReceiverPhone();
            if (phone == null || phone.length() < 4) {
                throw new BusinessException("该订单收货人手机号缺失，无法查询" + company.getCarrierName() + "轨迹");
            }
            param.put("phone", phone.substring(phone.length() - 4));
        }

        try {
            String paramJson = OBJECT_MAPPER.writeValueAsString(param);
            String sign = md5Upper(paramJson + logisticsProperties.getKey() + logisticsProperties.getCustomer());

            // 快递100 免费版响应 Content-Type 可能为 text/html，不能依赖 RestClient 的 JSON 转换器，取原始字符串手动解析
            String raw = restClientBuilder.build()
                    .post()
                    .uri(logisticsProperties.getUrl())
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .body("customer=" + logisticsProperties.getCustomer()
                            + "&sign=" + sign
                            + "&param=" + urlEncode(paramJson))
                    .retrieve()
                    .body(String.class);

            if (raw == null || raw.isBlank()) {
                throw new BusinessException("物流查询失败，请稍后重试");
            }
            Kuaidi100Response response;
            try {
                response = OBJECT_MAPPER.readValue(raw, Kuaidi100Response.class);
            } catch (Exception parseError) {
                // 非 JSON（HTML 错误页等）：多为授权/签名问题
                log.warn("快递100 返回非 JSON 响应：{}", raw.length() > 300 ? raw.substring(0, 300) : raw);
                throw new BusinessException("物流查询失败，请检查快递100 授权配置");
            }
            if (response == null || (response.status() == null && response.result() == null)) {
                throw new BusinessException("物流查询失败，请稍后重试");
            }
            if (Boolean.FALSE.equals(response.result()) || (response.status() != null && response.status() != 200)) {
                // 免费版两种未就绪形态：① {"result":false,"returnCode":"500","message":"查询无结果，请隔段时间再查"}（单号待同步/不存在）
                // ② {"status":"201/202",...}（收费版风格的状态码）——统一按"轨迹待同步"友好提示
                log.info("快递100 轨迹未就绪：orderNo={}, result={}, returnCode={}, status={}, message={}",
                        orderNo(logistics), response.result(), response.returnCode(), response.status(), response.message());
                throw new BusinessException("轨迹同步中，请稍后重试");
            }
            vo.setState(response.state());
            vo.setStateText(stateText(response.state()));
            List<LogisticsTrackVO.TrackNode> tracks = new ArrayList<>();
            if (response.data() != null) {                for (TrackItem item : response.data()) {
                    LogisticsTrackVO.TrackNode node = new LogisticsTrackVO.TrackNode();
                    node.setTime(item.ftime() != null ? item.ftime() : item.time());
                    node.setContext(item.context());
                    node.setLocation(item.location());
                    tracks.add(node);
                }
            }
            vo.setTracks(tracks);
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.warn("快递100 轨迹查询异常：orderNo={}", orderNo(logistics), e);
            throw new BusinessException("物流查询失败，请稍后重试");
        }
    }

    private LogisticsTrackVO readCache(String cacheKey) {
        try {
            String json = redisTemplate.opsForValue().get(cacheKey);
            return json == null ? null : OBJECT_MAPPER.readValue(json, LogisticsTrackVO.class);
        } catch (Exception e) {
            log.warn("物流轨迹缓存读取失败，按未命中处理", e);
            return null;
        }
    }

    private void writeCache(String cacheKey, LogisticsTrackVO vo) {
        try {
            String json = OBJECT_MAPPER.writeValueAsString(vo);
            redisTemplate.opsForValue().set(cacheKey, json, Duration.ofMinutes(logisticsProperties.getCacheTtlMinutes()));
        } catch (Exception e) {
            log.warn("物流轨迹缓存写入失败", e);
        }
    }

    private String md5Upper(String text) throws Exception {
        byte[] digest = java.security.MessageDigest.getInstance("MD5")
                .digest(text.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) {
            sb.append(String.format("%02X", b));
        }
        return sb.toString();
    }

    private String urlEncode(String text) {
        return java.net.URLEncoder.encode(text, StandardCharsets.UTF_8);
    }

    private String orderNo(OrderLogistics logistics) {
        return logistics.getOrderNo();
    }

    private String stateText(Integer state) {
        if (state == null) {
            return null;
        }
        return switch (state) {
            case 0 -> "运输中";
            case 1 -> "已揽收";
            case 2 -> "疑难件";
            case 3 -> "已签收";
            case 4 -> "已退签";
            case 5 -> "派送中";
            case 6 -> "已退回";
            default -> null;
        };
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record Kuaidi100Response(String message, Integer state, Integer status, Boolean isend, Boolean result,
                             String returnCode, List<TrackItem> data) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record TrackItem(String time, String ftime, String context, String location) {
    }
}
