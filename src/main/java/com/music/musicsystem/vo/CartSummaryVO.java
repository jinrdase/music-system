package com.music.musicsystem.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class CartSummaryVO {
    private List<CartItemVO> items;
    private Integer totalCount; // 购物车商品总件数
    private Integer selectedCount; // 已选中件数
    private BigDecimal totalAmount; // 鎬婚噾棰
    private BigDecimal selectedAmount; // 已选中金额
}