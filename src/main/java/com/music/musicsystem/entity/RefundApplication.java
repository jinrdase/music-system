package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */

@Data
@TableName("refund_application")
public class RefundApplication {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private String orderNo;

    private Long userId;

    private BigDecimal refundAmount;

    private String reason; // 退款原

    private String description; // 详细说明

    private String images; // 凭证图片（多张，逗号分隔

    private Integer status; // 0-待审核，1-审核通过-审核拒绝-退款成

    private String auditRemark; // 审核备注

    private Long auditorId; // 瀹℃牳浜篒D

    private LocalDateTime auditTime; // 审核时间

    private String returnCarrier;

    private String returnTrackingNo;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;
}