package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */

@Data
@TableName("order_info")
public class OrderInfo {
    @TableId(type = IdType.AUTO)
    private Long id;

    private String orderNo;
    private Long userId;
    private Long albumId;
    private String albumTitle;
    private String albumCover;
    private String productType;
    private Integer quantity;
    private BigDecimal price;
    private BigDecimal totalAmount;
    private Integer status;

    /** 订单形态：1-专辑订单，2-盲盒订单 */
    private Integer orderType;
    /** 盲盒订单关联的盲盒ID */
    private Long blindBoxId;
    /** 盲盒订单抽取次数（1或10） */
    private Integer drawCount;
    /** 盲盒抽取结果摘要 */
    private String drawSummary;

    // 新增：收货地址快照
    private String receiverName;
    private String receiverPhone;
    private String receiverProvince;
    private String receiverCity;
    private String receiverDistrict;
    private String receiverAddress;
    private LocalDateTime digitalContentAccessedAt;

    private LocalDateTime payTime;
    private LocalDateTime cancelTime;
    private LocalDateTime expireTime;
    private String remark;

    @TableLogic
    private Integer deleted;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}