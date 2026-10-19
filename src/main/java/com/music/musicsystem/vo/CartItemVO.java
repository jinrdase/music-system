package com.music.musicsystem.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class CartItemVO {
    private Long id;
    private Long albumId;
    private String albumName;
    private String albumCover;
    private BigDecimal price;
    private Integer quantity;
    private BigDecimal subtotal; // 灏忚
    private Integer isSelected;
    private Integer stock; // 库存
    private Integer isValid; // 0-失效-有效
    private LocalDateTime createTime;
}