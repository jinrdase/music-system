package com.music.musicsystem.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 物流轨迹视图对象。
 */
@Data
public class LogisticsTrackVO {

    /** 订单号 */
    private String orderNo;

    /** 承运商名 */
    private String carrier;

    /** 快递单号 */
    private String trackingNo;

    /** 发货时间 */
    private LocalDateTime shippedAt;

    /** 轨迹查询服务是否可用（未配置快递100 授权时为 false，前端只展示单号） */
    private boolean trackEnabled;

    /** 快递100 整体状态：0在途 1揽收 2疑难 3签收 4退签 5派件 6退回（未启用轨迹时为 null） */
    private Integer state;

    /** 状态中文描述 */
    private String stateText;

    /** 轨迹明细（按时间倒序，最新在前） */
    private List<TrackNode> tracks;

    @Data
    public static class TrackNode {

        /** 时间（快递100 ftime，格式化文本） */
        private String time;

        /** 轨迹描述 */
        private String context;

        /** 所在地（resultv2=6 时提供，可能为空） */
        private String location;
    }
}
