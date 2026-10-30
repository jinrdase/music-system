package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 订单明细：多商品订单的一行对应一件已购专辑，快照下单时的商品信息。
 */
@Data
@TableName("order_item")
public class OrderItem {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private String orderNo;

    private Long albumId;

    /** 专辑名称快照 */
    private String albumTitle;

    /** 专辑封面快照 */
    private String albumCover;

    /** 成交单价快照 */
    private BigDecimal price;

    private Integer quantity;

    /** 小计 = 单价 x 数量 */
    private BigDecimal subtotal;

    /** 商品形态快照：PHYSICAL-实物，DIGITAL-数字 */
    private String productType;

    /** 数字内容首次取阅时间（明细级退款闸门） */
    private LocalDateTime digitalContentAccessedAt;

    @TableLogic
    private Integer deleted;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
