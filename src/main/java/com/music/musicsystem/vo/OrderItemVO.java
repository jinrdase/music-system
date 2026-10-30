package com.music.musicsystem.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 订单明细视图对象。
 */
@Data
public class OrderItemVO {

    private Long id;

    private Long orderId;

    private String orderNo;

    private Long albumId;

    private String albumTitle;

    private String albumCover;

    /** 成交单价快照 */
    private BigDecimal price;

    private Integer quantity;

    private BigDecimal subtotal;

    /** 商品形态快照：PHYSICAL / DIGITAL */
    private String productType;

    /** 形态文案：实物 / 数字 */
    private String productTypeText;

    /** 数字内容首次取阅时间；null 表示尚未取阅 */
    private LocalDateTime digitalContentAccessedAt;
}
