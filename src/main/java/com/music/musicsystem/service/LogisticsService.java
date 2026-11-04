package com.music.musicsystem.service;

import com.music.musicsystem.vo.LogisticsTrackVO;

/**
 * 物流轨迹查询服务。
 */
public interface LogisticsService {

    /**
     * 查询订单物流轨迹（校验归属与状态，快递100 授权未配置时降级为仅返回承运商与单号）。
     */
    LogisticsTrackVO getTrack(Long userId, String orderNo);
}
