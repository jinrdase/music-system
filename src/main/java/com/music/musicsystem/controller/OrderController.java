package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.CreateFromCartDTO;
import com.music.musicsystem.dto.CreateOrderDTO;
import com.music.musicsystem.dto.ShipOrderDTO;
import com.music.musicsystem.service.OrderService;
import com.music.musicsystem.vo.OrderItemVO;
import com.music.musicsystem.vo.OrderVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 处理用户订单查询、创建及数字内容交付请求。
 */

@RestController
@RequestMapping("/api/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    /**
     * 创建订单。
     */
    @PostMapping("/create")
    public Result<OrderVO> createOrder(
            @Validated @RequestBody CreateOrderDTO dto,
            HttpServletRequest request
    ) {
        Long userId = (Long) request.getAttribute("userId");
        OrderVO orderVO = orderService.createOrder(userId, dto);
        return Result.success("下单成功", orderVO);
    }

    /**
     * 购物车合并结算：已勾选商品合并为一张多明细订单。
     */
    @PostMapping("/createFromCart")
    public Result<OrderVO> createFromCart(
            @Validated @RequestBody CreateFromCartDTO dto,
            HttpServletRequest request
    ) {
        Long userId = (Long) request.getAttribute("userId");
        OrderVO orderVO = orderService.createFromCart(userId, dto);
        return Result.success("结算成功", orderVO);
    }

    /**
     * 取消订单
     */
    @PostMapping("/cancel/{orderNo}")
    public Result<Void> cancelOrder(
            @PathVariable String orderNo,
            HttpServletRequest request
    ) {
        Long userId = (Long) request.getAttribute("userId");
        orderService.cancelOrder(userId, orderNo);
        return Result.success("订单已取消", null);
    }

    /**
     * 管理员标记订单已发货
     */
    @PutMapping("/ship/{orderNo}")
    public Result<Void> shipOrder(
            @PathVariable String orderNo,
            @Validated @RequestBody ShipOrderDTO dto,
            HttpServletRequest request
    ) {
        String role = (String) request.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role) && !"super_admin".equalsIgnoreCase(role)) {
            throw new BusinessException(403, "无权执行发货操作");
        }
        orderService.shipOrder(orderNo, dto);
        return Result.success("订单已标记为发货", null);
    }

    /**
     * 确认收货
     */
    @PostMapping("/confirmReceipt/{orderNo}")
    public Result<Void> confirmReceipt(
            @PathVariable String orderNo,
            HttpServletRequest request
    ) {
        Long userId = (Long) request.getAttribute("userId");
        orderService.confirmReceipt(userId, orderNo);
        return Result.success("已确认收货", null);
    }

    /**
     * 查询我的订单列表
     */
    @GetMapping("/my")
    public Result<Page<OrderVO>> getMyOrders(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request
    ) {
        Long userId = (Long) request.getAttribute("userId");
        Page<OrderVO> page = orderService.getUserOrders(userId, current, size);
        return Result.success(page);
    }

    /**
     * 获取订单详情
     */
    @GetMapping("/{orderNo}")
    public Result<OrderVO> getOrderDetail(
            @PathVariable String orderNo,
            HttpServletRequest request
    ) {
        Long userId = (Long) request.getAttribute("userId");
        OrderVO orderVO = orderService.getOrderDetail(userId, orderNo);
        return Result.success(orderVO);
    }
    /**
     * 获取已完成支付订单对应的数字内容。
     */

    @GetMapping("/{orderNo}/digital-content")
    public Result<String> getDigitalContent(@PathVariable String orderNo, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(orderService.getDigitalContent(userId, orderNo));
    }

    /**
     * 订单明细列表（订单所有者或管理员；历史单商品订单合成单条返回）。
     */
    @GetMapping("/{orderNo}/items")
    public Result<List<OrderItemVO>> getOrderItems(@PathVariable String orderNo, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        boolean isAdmin = "admin".equalsIgnoreCase(role) || "super_admin".equalsIgnoreCase(role);
        return Result.success(orderService.getOrderItems(userId, orderNo, isAdmin));
    }

    /**
     * 明细级数字内容取阅：一张订单中的每件数字商品独立取阅。
     */
    @GetMapping("/{orderNo}/digital-content/{itemId}")
    public Result<String> getDigitalContentByItem(
            @PathVariable String orderNo,
            @PathVariable Long itemId,
            HttpServletRequest request
    ) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(orderService.getDigitalContentByItem(userId, orderNo, itemId));
    }
}