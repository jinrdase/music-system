package com.music.musicsystem.service;

import com.music.musicsystem.dto.CartItemDTO;
import com.music.musicsystem.vo.CartSummaryVO;

import java.util.List;

/**
 * 定义购物车商品维护和汇总操作。
 */

public interface ShoppingCartService {

    /**
     * 加入购物
     */
    void addToCart(Long userId, CartItemDTO dto);

    /**
     * 更新购物车商品数
     */
    void updateQuantity(Long userId, Long cartId, Integer quantity);

    /**
     * 删除购物车商
     */
    void removeFromCart(Long userId, Long cartId);

    /**
     * 批量删除购物车商
     */
    void batchRemove(Long userId, List<Long> cartIds);

    /**
     * 清空购物车。
     */
    void clearCart(Long userId);

    /**
     * 选中/取消选中商品
     */
    void toggleSelect(Long userId, Long cartId, Integer isSelected);

    /**
     * 全取消全
     */
    void toggleSelectAll(Long userId, Integer isSelected);

    /**
     * 查询购物车列
     */
    CartSummaryVO getCartSummary(Long userId);

    /**
     * 清理失效商品
     */
    void clearInvalidItems(Long userId);
}