package com.music.musicsystem.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.IService;
import com.music.musicsystem.dto.CreateOrderDTO;
import com.music.musicsystem.dto.ShipOrderDTO;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.vo.OrderVO;

/**
 * 定义订单创建、查询、状态流转及履约操作。
 */

public interface OrderService extends IService<OrderInfo> {

    /**
     * 创建订单（秒杀防超卖）
     */
    OrderVO createOrder(Long userId, CreateOrderDTO dto);

    /**
     * 取消订单
     */
    void cancelOrder(Long userId, String orderNo);

    /**
     * 管理员标记订单已发货
     */
    void shipOrder(String orderNo, ShipOrderDTO dto);

    /**
     * 确认收货并完成订单
     */
    void confirmReceipt(Long userId, String orderNo);

    /**
     * 查询用户订单列表
     */
    Page<OrderVO> getUserOrders(
            Long userId,
            Integer current,
            Integer size
    );

    /**
     * 处理支付成功回调
     */
    void handlePaymentSuccess(Long orderId);

    /**
     * 获取订单详情
     */
    OrderVO getOrderDetail(Long userId, String orderNo);

    /**
     * 获取订单中已支付商品的数字内容。
     */
    String getDigitalContent(Long userId, String orderNo);
}