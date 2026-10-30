package com.music.musicsystem.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class OrderVO {

    private Long id;
    private String orderNo;
    private Long userId;
    private Long albumId;
    private String albumTitle;
    private String albumCover;
    private String productType;
    /** 订单形态：1-专辑订单，2-盲盒订单 */
    private Integer orderType;
    private String receiverName;
    private String receiverPhone;
    private String receiverProvince;
    private String receiverCity;
    private String receiverDistrict;
    private String receiverAddress;
    private Integer quantity;
    private BigDecimal price;
    private BigDecimal totalAmount;
    private Integer status;
    private String statusText;
    private LocalDateTime payTime;
    private String carrier;
    private String trackingNo;
    private LocalDateTime shippedAt;
    private LocalDateTime cancelTime;
    private LocalDateTime expireTime;
    private String remark;
    private LocalDateTime createTime;
    /** 订单明细（订单详情/明细查询接口返回；多商品订单为多条，旧单商品订单为单条） */
    private List<OrderItemVO> items;
}