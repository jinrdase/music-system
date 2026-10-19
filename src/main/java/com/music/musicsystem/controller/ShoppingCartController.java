package com.music.musicsystem.controller;

import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.CartItemDTO;
import com.music.musicsystem.service.ShoppingCartService;
import com.music.musicsystem.util.JwtUtil;
import com.music.musicsystem.vo.CartSummaryVO;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 处理用户购物车商品和结算信息请求。
 */

@RestController
@RequestMapping("/api/cart")
public class ShoppingCartController {

    @Resource
    private ShoppingCartService shoppingCartService;

    @Resource
    private JwtUtil jwtUtil;

    /**
     * 加入购物
     */
    @PostMapping("/add")
    public Result<Void> addToCart(@Validated @RequestBody CartItemDTO dto,
                                  HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        shoppingCartService.addToCart(userId, dto);
        return Result.success();
    }

    /**
     * 更新商品数量
     */
    @PutMapping("/updateQuantity/{cartId}")
    public Result<Void> updateQuantity(@PathVariable Long cartId,
                                       @RequestParam Integer quantity,
                                       HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        shoppingCartService.updateQuantity(userId, cartId, quantity);
        return Result.success();
    }

    /**
     * 删除购物车商
     */
    @DeleteMapping("/remove/{cartId}")
    public Result<Void> removeFromCart(@PathVariable Long cartId,
                                       HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        shoppingCartService.removeFromCart(userId, cartId);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/batchRemove")
    public Result<Void> batchRemove(@RequestBody List<Long> cartIds,
                                    HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        shoppingCartService.batchRemove(userId, cartIds);
        return Result.success();
    }

    /**
     * 清空购物车。
     */
    @DeleteMapping("/clear")
    public Result<Void> clearCart(HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        shoppingCartService.clearCart(userId);
        return Result.success();
    }

    /**
     * 选中/取消选中商品
     */
    @PutMapping("/toggleSelect/{cartId}")
    public Result<Void> toggleSelect(@PathVariable Long cartId,
                                     @RequestParam Integer isSelected,
                                     HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        shoppingCartService.toggleSelect(userId, cartId, isSelected);
        return Result.success();
    }

    /**
     * 全取消全
     */
    @PutMapping("/toggleSelectAll")
    public Result<Void> toggleSelectAll(@RequestParam Integer isSelected,
                                        HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        shoppingCartService.toggleSelectAll(userId, isSelected);
        return Result.success();
    }

    /**
     * 查询购物
     */
    @GetMapping("/list")
    public Result<CartSummaryVO> getCartSummary(HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        CartSummaryVO summary = shoppingCartService.getCartSummary(userId);
        return Result.success(summary);
    }

    /**
     * 清理失效商品
     */
    @DeleteMapping("/clearInvalid")
    public Result<Void> clearInvalidItems(HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        shoppingCartService.clearInvalidItems(userId);
        return Result.success();
    }

    /**
     * 从Token获取当前用户ID
     */
    private Long getCurrentUserId(HttpServletRequest request) {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        return jwtUtil.getUserIdFromToken(token);
    }
}