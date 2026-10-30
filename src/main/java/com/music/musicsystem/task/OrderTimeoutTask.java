package com.music.musicsystem.task;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.music.musicsystem.common.constant.OrderStatus;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.service.OrderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 订单超时处理定时任务
 * 每分钟扫描一次超时未支付的订单，自动取消并恢复库
 */
@Component
@Slf4j
public class OrderTimeoutTask {

    @Autowired
    private OrderService orderService;

    /**
     * 定时扫描超时订单
     * cron表达式：每分钟执行一次（周）
     */
    @Scheduled(cron = "0 */1 * * * ?")
    public void cancelExpiredOrders() {
        log.info("========== 开始扫描超时订单 ==========");

        try {
            // 查询超时未支付的订单
            LambdaQueryWrapper<OrderInfo> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(OrderInfo::getStatus, OrderStatus.UNPAID)
                    .lt(OrderInfo::getExpireTime, LocalDateTime.now());

            List<OrderInfo> expiredOrders = orderService.list(wrapper);

            if (expiredOrders == null || expiredOrders.isEmpty()) {
                log.info("未发现超时订单");
                return;
            }

            log.info("发现 {} 个超时订单，开始自动取消", expiredOrders.size());

            int successCount = 0;
            int failCount = 0;

            // 逐个取消超时订单
            for (OrderInfo order : expiredOrders) {
                try {
                    // 调用 cancelOrder 方法，传userId orderNo
                    orderService.cancelOrder(order.getUserId(), order.getOrderNo());
                    successCount++;
                    log.info("订单 {} 超时自动取消成功，用户ID：{}，专辑ID：{}，数量：{}",
                            order.getOrderNo(),
                            order.getUserId(),
                            order.getAlbumId(),
                            order.getQuantity());
                } catch (Exception e) {
                    failCount++;
                    log.error("取消订单 {} 失败：{}", order.getOrderNo(), e.getMessage(), e);
                }
            }

            log.info("超时订单处理完成，成功：{}，失败：{}", successCount, failCount);

        } catch (Exception e) {
            log.error("扫描超时订单任务执行异常", e);
        }

        log.info("========== 超时订单扫描结束 ==========");
    }
}