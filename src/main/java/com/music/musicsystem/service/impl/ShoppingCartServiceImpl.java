package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.dto.CartItemDTO;
import com.music.musicsystem.entity.Album;
import com.music.musicsystem.entity.ShoppingCart;
import com.music.musicsystem.mapper.AlbumMapper;
import com.music.musicsystem.mapper.ShoppingCartMapper;
import com.music.musicsystem.service.ShoppingCartService;
import com.music.musicsystem.vo.CartItemVO;
import com.music.musicsystem.vo.CartSummaryVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 实现购物车商品维护、勾选和金额汇总业务。
 */

@Service
public class ShoppingCartServiceImpl implements ShoppingCartService {

    @Resource
    private ShoppingCartMapper shoppingCartMapper;

    @Resource
    private AlbumMapper albumMapper;

    private static final Integer MAX_CART_ITEMS = 50;
    private static final Integer MAX_ITEM_QUANTITY = 10;
    /**
     * 向当前用户购物车添加商品。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addToCart(Long userId, CartItemDTO dto) {
        // 1. 校验专辑是否存在且上
        Album album = albumMapper.selectById(dto.getAlbumId());
        if (album == null) {
            throw new BusinessException("专辑不存在");
        }
        if (album.getStatus() != 1) {
            throw new BusinessException("该专辑已下架");
        }

        // 2. 校验库存
        if (album.getStock() < dto.getQuantity()) {
            throw new BusinessException("库存不足，最多可购买" + album.getStock() + "件");
        }

        // 3. 检查购物车是否已有该商
        ShoppingCart existingCart = shoppingCartMapper.selectOne(
                new LambdaQueryWrapper<ShoppingCart>()
                        .eq(ShoppingCart::getUserId, userId)
                        .eq(ShoppingCart::getAlbumId, dto.getAlbumId())
        );

        if (existingCart != null) {
            // 已存在，更新数量
            Integer newQuantity = existingCart.getQuantity() + dto.getQuantity();
            if (newQuantity > MAX_ITEM_QUANTITY) {
                throw new BusinessException("该商品限购" + MAX_ITEM_QUANTITY + "件");
            }
            if (newQuantity > album.getStock()) {
                throw new BusinessException("库存不足");
            }
            existingCart.setQuantity(newQuantity);
            shoppingCartMapper.updateById(existingCart);
        } else {
            // 4. 检查购物车商品数量限制
            Long cartCount = shoppingCartMapper.selectCount(
                    new LambdaQueryWrapper<ShoppingCart>().eq(ShoppingCart::getUserId, userId)
            );
            if (cartCount >= MAX_CART_ITEMS) {
                throw new BusinessException("购物车最多添加" + MAX_CART_ITEMS + "件商品");
            }

        // 5. 新增购物车记录。
            ShoppingCart cart = new ShoppingCart();
            cart.setUserId(userId);
            cart.setAlbumId(dto.getAlbumId());
            cart.setAlbumName(album.getTitle());
            cart.setAlbumCover(album.getCoverUrl());
            cart.setPrice(album.getPrice());
            cart.setQuantity(dto.getQuantity());
            cart.setIsSelected(1); // 默认选中
            shoppingCartMapper.insert(cart);
        }
    }
    /**
     * 更新购物车商品数量。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateQuantity(Long userId, Long cartId, Integer quantity) {
        // 1. 校验购物车记录归属。
        ShoppingCart cart = getAndCheckCart(userId, cartId);

        // 2. 校验数量。
        if (quantity < 1) {
            throw new BusinessException("购买数量至少为1");
        }
        if (quantity > MAX_ITEM_QUANTITY) {
            throw new BusinessException("该商品限购" + MAX_ITEM_QUANTITY + "件");
        }

        // 3. 校验库存
        Album album = albumMapper.selectById(cart.getAlbumId());
        if (album == null || album.getStatus() != 1) {
            throw new BusinessException("商品已失效");
        }
        if (quantity > album.getStock()) {
            throw new BusinessException("库存不足，最多可购买" + album.getStock() + "件");
        }

        // 4. 更新数量
        cart.setQuantity(quantity);
        shoppingCartMapper.updateById(cart);
    }
    /**
     * 从当前用户购物车移除指定商品。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void removeFromCart(Long userId, Long cartId) {
        getAndCheckCart(userId, cartId);
        shoppingCartMapper.deleteById(cartId);
    }
    /**
     * 批量移除当前用户购物车中的商品。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void batchRemove(Long userId, List<Long> cartIds) {
        if (cartIds == null || cartIds.isEmpty()) {
            return;
        }

        // 验证所有购物车项归
        for (Long cartId : cartIds) {
            getAndCheckCart(userId, cartId);
        }

        shoppingCartMapper.deleteBatchIds(cartIds);
    }
    /**
     * 清空当前用户购物车。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void clearCart(Long userId) {
        shoppingCartMapper.delete(
                new LambdaQueryWrapper<ShoppingCart>().eq(ShoppingCart::getUserId, userId)
        );
    }
    /**
     * 切换购物车单个商品的选中状态。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void toggleSelect(Long userId, Long cartId, Integer isSelected) {
        getAndCheckCart(userId, cartId);

        shoppingCartMapper.update(null,
                new LambdaUpdateWrapper<ShoppingCart>()
                        .set(ShoppingCart::getIsSelected, isSelected)
                        .eq(ShoppingCart::getId, cartId)
        );
    }
    /**
     * 设置当前用户购物车商品的统一选中状态。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void toggleSelectAll(Long userId, Integer isSelected) {
        shoppingCartMapper.update(null,
                new LambdaUpdateWrapper<ShoppingCart>()
                        .set(ShoppingCart::getIsSelected, isSelected)
                        .eq(ShoppingCart::getUserId, userId)
        );
    }
    /**
     * 汇总购物车商品数量及金额信息。
     */

    @Override
    public CartSummaryVO getCartSummary(Long userId) {
        // 1. 查询购物车列
        List<ShoppingCart> cartList = shoppingCartMapper.selectList(
                new LambdaQueryWrapper<ShoppingCart>()
                        .eq(ShoppingCart::getUserId, userId)
                        .orderByDesc(ShoppingCart::getCreateTime)
        );

        // 2. 转换为VO并校验有效
        List<CartItemVO> items = cartList.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());

        // 3. 计算汇总信
        CartSummaryVO summary = new CartSummaryVO();
        summary.setItems(items);
        summary.setTotalCount(items.size());

        int selectedCount = 0;
        BigDecimal selectedAmount = BigDecimal.ZERO;
        BigDecimal totalAmount = BigDecimal.ZERO;

        for (CartItemVO item : items) {
            BigDecimal subtotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
            item.setSubtotal(subtotal);
            totalAmount = totalAmount.add(subtotal);

            if (item.getIsSelected() == 1 && item.getIsValid() == 1) {
                selectedCount++;
                selectedAmount = selectedAmount.add(subtotal);
            }
        }

        summary.setSelectedCount(selectedCount);
        summary.setTotalAmount(totalAmount);
        summary.setSelectedAmount(selectedAmount);

        return summary;
    }
    /**
     * 清理购物车中已失效或不可购买的商品。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void clearInvalidItems(Long userId) {
        List<ShoppingCart> cartList = shoppingCartMapper.selectList(
                new LambdaQueryWrapper<ShoppingCart>().eq(ShoppingCart::getUserId, userId)
        );

        for (ShoppingCart cart : cartList) {
            Album album = albumMapper.selectById(cart.getAlbumId());
            if (album == null || album.getStatus() != 1 || album.getStock() == 0) {
                shoppingCartMapper.deleteById(cart.getId());
            }
        }
    }

    /**
     * 获取购物车项并校验归
     */
    private ShoppingCart getAndCheckCart(Long userId, Long cartId) {
        ShoppingCart cart = shoppingCartMapper.selectById(cartId);
        if (cart == null) {
            throw new BusinessException("购物车商品不存在");
        }
        if (!cart.getUserId().equals(userId)) {
            throw new BusinessException("无权操作该购物车商品");
        }
        return cart;
    }

    /**
     * 实体转VO，并校验商品有效
     */
    private CartItemVO convertToVO(ShoppingCart cart) {
        CartItemVO vo = new CartItemVO();
        BeanUtils.copyProperties(cart, vo);

        // 鏍￠獙鍟嗗搧鏈夋晥鎬
        Album album = albumMapper.selectById(cart.getAlbumId());
        if (album == null || album.getStatus() != 1) {
            vo.setIsValid(0);
            vo.setStock(0);
        } else {
            vo.setIsValid(1);
            vo.setStock(album.getStock());
            // 更新价格（防止商品价格变动）
            vo.setPrice(album.getPrice());
        }

        return vo;
    }
}