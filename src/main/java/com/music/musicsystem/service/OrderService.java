package com.music.musicsystem.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.IService;
import com.music.musicsystem.dto.CreateFromCartDTO;
import com.music.musicsystem.dto.CreateOrderDTO;
import com.music.musicsystem.dto.ShipOrderDTO;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.vo.AdminOrderVO;
import com.music.musicsystem.vo.OrderItemVO;
import com.music.musicsystem.vo.OrderVO;

import java.util.List;

/**
 * 定义订单创建、查询、状态流转及履约操作。
 */

public interface OrderService extends IService<OrderInfo> {

    /**
     * 创建订单（秒杀防超卖）。内部生成单明细订单，与购物车合并结算共用 order_item 结构。
     */
    OrderVO createOrder(Long userId, CreateOrderDTO dto);

    /**
     * 购物车合并结算：把已勾选商品合并为一张多明细订单（整单拒绝策略）。
     */
    OrderVO createFromCart(Long userId, CreateFromCartDTO dto);

    /**
     * 查询订单明细（订单所有者或管理员；无明细的历史订单按订单级字段合成单条返回）。
     */
    List<OrderItemVO> getOrderItems(Long userId, String orderNo, boolean isAdmin);

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
     * 恢复订单占用的库存（用户取消 / 超时关单 / 退款执行共用）。
     * 按 order_info 快照回补专辑库存并写入 type=2 库存流水。
     */
    void restoreStock(OrderInfo order);

    /**
     * 获取订单详情
     */
    OrderVO getOrderDetail(Long userId, String orderNo);

    /**
     * 获取订单中已支付商品的数字内容。
     */
    String getDigitalContent(Long userId, String orderNo);

    /**
     * 明细级数字内容取阅：订单内每件数字商品独立取阅、独立记录首次取阅时间。
     * 无明细的历史订单回退为订单级处理。
     */
    String getDigitalContentByItem(Long userId, String orderNo, Long itemId);

    /**
     * 后台订单列表：分页 + 状态/订单号/用户/创建时间范围筛选（只读，按创建时间倒序）。
     */
    Page<AdminOrderVO> getAdminOrders(Integer current, Integer size, Integer status,
                                      String orderNo, Long userId, String startDate, String endDate);
}