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
    private Integer totalCount; // 购物车商品种类数（非件数）
    private Integer selectedCount; // 已选中的商品种类数
    private BigDecimal totalAmount; // 有效商品总额（不含失效项）
    private BigDecimal selectedAmount; // 已选中金额
}