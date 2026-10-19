package com.music.musicsystem.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class RefundApplicationVO {
    private Long id;
    private Long orderId;
    private String orderNo;
    private BigDecimal refundAmount;
    private String reason;
    private String description;
    private List<String> images;
    private String returnCarrier;
    private String returnTrackingNo;
    private Integer status;
    private String auditRemark;
    private Long auditorId;
    private LocalDateTime auditTime;
    private LocalDateTime createTime;
}