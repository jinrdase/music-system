package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.impl.ServiceImpl;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.constant.OrderStatus;
import com.music.musicsystem.common.constant.ProductType;
import com.music.musicsystem.common.constant.RefundStatus;
import com.music.musicsystem.dto.CreateOrderDTO;
import com.music.musicsystem.dto.ShipOrderDTO;
import com.music.musicsystem.entity.Album;
import com.music.musicsystem.entity.OrderLogistics;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.entity.RefundApplication;
import com.music.musicsystem.entity.StockLog;
import com.music.musicsystem.entity.UserAddress;
import com.music.musicsystem.mapper.AlbumMapper;
import com.music.musicsystem.mapper.OrderInfoMapper;
import com.music.musicsystem.mapper.OrderLogisticsMapper;
import com.music.musicsystem.mapper.RefundApplicationMapper;
import com.music.musicsystem.mapper.StockLogMapper;
import com.music.musicsystem.mapper.UserAddressMapper;
import com.music.musicsystem.service.OrderService;
import com.music.musicsystem.util.RedisUtil;
import com.music.musicsystem.vo.OrderVO;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * 实现订单创建、支付状态流转和商品履约业务。
 */

@Service
@Slf4j
public class OrderServiceImpl extends ServiceImpl<OrderInfoMapper, OrderInfo> implements OrderService {

    @Autowired
    private AlbumMapper albumMapper;

    @Autowired
    private StockLogMapper stockLogMapper;

    @Autowired
    private OrderInfoMapper orderInfoMapper;

    @Autowired
    private OrderLogisticsMapper orderLogisticsMapper;

    @Autowired
    private RefundApplicationMapper refundApplicationMapper;

    @Autowired
    private UserAddressMapper userAddressMapper;


    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private RedissonClient redissonClient;

    private static final String STOCK_PREFIX = "album:stock:";
    private static final String LOCK_PREFIX = "album:lock:";
    /**
     * 在支付成功后推进订单及相关业务状态。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void handlePaymentSuccess(Long orderId) {
        OrderInfo order = orderInfoMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException("订单不存在");
        }

        // 更新订单状态为已支
        order.setStatus(1);
        order.setPayTime(LocalDateTime.now());
        orderInfoMapper.updateById(order);

        // TODO: 发送支付成功通知（短站内信）
        // TODO: 清空该用户购物车中已购买商品
    }
    /**
     * 创建订单（秒杀防超卖核心逻辑
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public OrderVO createOrder(Long userId, CreateOrderDTO dto) {
        Long albumId = dto.getAlbumId();
        Integer quantity = dto.getQuantity();
        Long addressId = dto.getAddressId();  // 新增：获取地址ID

        // 1. 查询专辑信息
        Album album = albumMapper.selectById(albumId);
        if (album == null) {
            throw new BusinessException("专辑不存在");
        }
        if (album.getStatus() != 1) {
            throw new BusinessException("专辑已下架");
        }

        UserAddress address = null;
        if (ProductType.isPhysical(album.getProductType())) {
            if (addressId == null) {
                throw new BusinessException("购买实物商品必须选择收货地址");
            }
            address = userAddressMapper.selectById(addressId);
            if (address == null || address.getDeleted() == 1) {
                throw new BusinessException("收货地址不存在");
            }
            if (!address.getUserId().equals(userId)) {
                throw new BusinessException("无权使用此地址");
            }
        } else if (addressId != null) {
            throw new BusinessException("数字商品无需填写收货地址");
        }

        // 3. 获取分布式锁（防止并发问题）
        String lockKey = LOCK_PREFIX + albumId;
        RLock lock = redissonClient.getLock(lockKey);

        try {
            // 尝试获取锁，最多等待5秒，锁10秒后自动释放
            boolean locked = lock.tryLock(5, 10, TimeUnit.SECONDS);
            if (!locked) {
                throw new BusinessException("系统繁忙，请稍后再试");
            }

            // 4. Redis 库存预扣（第一层防护）
            String stockKey = STOCK_PREFIX + albumId;

            // 如果 Redis 中没有库存，从数据库加载
            if (!redisUtil.hasKey(stockKey)) {
                redisUtil.set(stockKey, album.getStock());
            }

            // Redis 扣减库存
            Long remainStock = redisUtil.decrement(stockKey, quantity);
            if (remainStock < 0) {
                // 库存不足，回滚
                redisUtil.increment(stockKey, quantity);
                throw new BusinessException("库存不足");
            }

            // 5. MySQL 乐观锁扣减库存（第二层防护）
            LambdaUpdateWrapper<Album> updateWrapper = new LambdaUpdateWrapper<>();
            updateWrapper.eq(Album::getId, albumId)
                    .ge(Album::getStock, quantity) // 乐观锁：库存必须大于等于购买数量
                    .setSql("stock = stock - " + quantity)
                    .setSql("sales = sales + " + quantity);

            int updated = albumMapper.update(null, updateWrapper);
            if (updated == 0) {
                // MySQL 扣减失败，回滚 Redis
                redisUtil.increment(stockKey, quantity);
                throw new BusinessException("库存不足或库存已被占用");
            }

            // 6. 记录库存流水
            Album updatedAlbum = albumMapper.selectById(albumId);
            StockLog stockLog = new StockLog();
            stockLog.setAlbumId(albumId);
            stockLog.setQuantity(quantity);
            stockLog.setBeforeStock(updatedAlbum.getStock() + quantity);
            stockLog.setAfterStock(updatedAlbum.getStock());
            stockLog.setType(1); // 1-下单扣减
            stockLog.setRemark("用户下单扣减库存");

            // 7. 创建订单
            OrderInfo order = new OrderInfo();
            order.setOrderNo(generateOrderNo());
            order.setUserId(userId);
            order.setAlbumId(albumId);
            order.setAlbumTitle(album.getTitle());
            order.setAlbumCover(album.getCoverUrl());
            order.setQuantity(quantity);
            order.setPrice(album.getPrice());
            order.setTotalAmount(album.getPrice().multiply(new BigDecimal(quantity)));
            order.setStatus(0); // 0-待支付
            order.setExpireTime(LocalDateTime.now().plusMinutes(15)); // 15分钟后过期
            order.setRemark(dto.getRemark());

            order.setProductType(album.getProductType());
            if (address != null) {
                order.setReceiverName(address.getReceiverName());
                order.setReceiverPhone(address.getReceiverPhone());
                order.setReceiverProvince(address.getProvince());
                order.setReceiverCity(address.getCity());
                order.setReceiverDistrict(address.getDistrict());
                order.setReceiverAddress(address.getDetailAddress());
            }

            this.save(order);

            // 关联订单号
            stockLog.setOrderNo(order.getOrderNo());
            stockLogMapper.insert(stockLog);

            log.info("订单创建成功：订单号={}, 用户ID={}, 专辑ID={}, 数量={}, 收货人={}",
                    order.getOrderNo(), userId, albumId, quantity,
                    address == null ? "数字商品" : address.getReceiverName());

            // 8. 返回订单信息
            return convertToVO(order);

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("创建订单失败", e);
            throw new BusinessException("创建订单失败：" + e.getMessage());
        } finally {
            // 释放锁
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }
    /**
     * 取消订单
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelOrder(Long userId, String orderNo) {
        // 1. 查询订单
        LambdaQueryWrapper<OrderInfo> query = new LambdaQueryWrapper<>();
        query.eq(OrderInfo::getOrderNo, orderNo)
                .eq(OrderInfo::getUserId, userId);
        OrderInfo order = this.getOne(query);

        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        if (!ProductType.isPhysical(order.getProductType())) {
            throw new BusinessException("数字商品订单不需要物流发货");
        }
        if (order.getStatus() != 0) {
            throw new BusinessException("只能取消待支付订单");
        }

        // 2. 更新订单状态为"已取
        order.setStatus(3); // 修改-已取消（不是2
        order.setCancelTime(LocalDateTime.now());
        this.updateById(order);

        // 3. 恢复库存
        restoreStock(order);

        log.info("订单取消成功：订单号={}, 用户ID={}", orderNo, userId);
    }

    /**
     * 仅允许将已支付订单标记为已发货。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void shipOrder(String orderNo, ShipOrderDTO dto) {
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, orderNo)
        );
        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        if (!OrderStatus.PAID.equals(order.getStatus())) {
            throw new BusinessException("只有已支付订单可以标记发货");
        }

        OrderLogistics logistics = new OrderLogistics();
        logistics.setOrderId(order.getId());
        logistics.setOrderNo(order.getOrderNo());
        logistics.setCarrier(dto.getCarrier().trim());
        logistics.setTrackingNo(dto.getTrackingNo().trim());
        logistics.setShippedAt(LocalDateTime.now());
        orderLogisticsMapper.insert(logistics);

        int updated = orderInfoMapper.update(
                null,
                new LambdaUpdateWrapper<OrderInfo>()
                        .eq(OrderInfo::getId, order.getId())
                        .eq(OrderInfo::getStatus, OrderStatus.PAID)
                        .set(OrderInfo::getStatus, OrderStatus.SHIPPED)
        );
        if (updated == 0) {
            throw new BusinessException("订单状态已变化，请刷新后重试");
        }
    }

    /**
     * 确认收货：只允许订单所有者将已发货订单变更为已完成。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmReceipt(Long userId, String orderNo) {
        OrderInfo order = orderInfoMapper.selectOne(
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getOrderNo, orderNo)
                        .eq(OrderInfo::getUserId, userId)
        );
        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        if (!OrderStatus.SHIPPED.equals(order.getStatus())) {
            throw new BusinessException("只有已发货订单可以确认收货");
        }

        Long activeRefunds = refundApplicationMapper.selectCount(
                new LambdaQueryWrapper<RefundApplication>()
                        .eq(RefundApplication::getOrderId, order.getId())
                        .in(RefundApplication::getStatus, RefundStatus.PENDING, RefundStatus.APPROVED)
        );
        if (activeRefunds != null && activeRefunds > 0) {
            throw new BusinessException("退款申请处理完成前不能确认收货");
        }

        int updated = orderInfoMapper.update(
                null,
                new LambdaUpdateWrapper<OrderInfo>()
                        .eq(OrderInfo::getId, order.getId())
                        .eq(OrderInfo::getUserId, userId)
                        .eq(OrderInfo::getStatus, OrderStatus.SHIPPED)
                        .set(OrderInfo::getStatus, OrderStatus.COMPLETED)
        );
        if (updated == 0) {
            throw new BusinessException("订单状态已变化，请刷新后重试");
        }
    }

    /**
     * 查询用户订单列表
     */
    @Override
    public Page<OrderVO> getUserOrders(Long userId, Integer current, Integer size) {
        LambdaQueryWrapper<OrderInfo> query = new LambdaQueryWrapper<>();
        query.eq(OrderInfo::getUserId, userId)
                .orderByDesc(OrderInfo::getCreateTime);

        Page<OrderInfo> page = new Page<>(current, size);
        this.page(page, query);

        Page<OrderVO> voPage = new Page<>(current, size, page.getTotal());
        List<OrderVO> voList = page.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
        voPage.setRecords(voList);

        return voPage;
    }

    /**
     * 获取订单详情
     */
    @Override
    public OrderVO getOrderDetail(Long userId, String orderNo) {
        LambdaQueryWrapper<OrderInfo> query = new LambdaQueryWrapper<>();
        query.eq(OrderInfo::getOrderNo, orderNo)
                .eq(OrderInfo::getUserId, userId);
        OrderInfo order = this.getOne(query);

        if (order == null) {
            throw new BusinessException("订单不存在");
        }

        OrderVO vo = convertToVO(order);
        if (OrderStatus.SHIPPED.equals(order.getStatus()) || OrderStatus.COMPLETED.equals(order.getStatus())) {
            OrderLogistics logistics = orderLogisticsMapper.selectOne(
                    new LambdaQueryWrapper<OrderLogistics>().eq(OrderLogistics::getOrderId, order.getId())
            );
            if (logistics != null) {
                vo.setCarrier(logistics.getCarrier());
                vo.setTrackingNo(logistics.getTrackingNo());
                vo.setShippedAt(logistics.getShippedAt());
            }
        }
        return vo;
    }
    /**
     * 获取已完成支付订单对应的数字内容。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String getDigitalContent(Long userId, String orderNo) {
        OrderInfo order = orderInfoMapper.selectOne(new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getOrderNo, orderNo)
                .eq(OrderInfo::getUserId, userId)
                .last("FOR UPDATE"));
        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        if (!ProductType.isDigital(order.getProductType())) {
            throw new BusinessException("该订单不是数字商品订单");
        }
        if (!OrderStatus.PAID.equals(order.getStatus()) && !OrderStatus.COMPLETED.equals(order.getStatus())) {
            throw new BusinessException("订单支付完成后才能获取数字内容");
        }
        Album album = albumMapper.selectById(order.getAlbumId());
        if (album == null || album.getDigitalContentUrl() == null || album.getDigitalContentUrl().isBlank()) {
            throw new BusinessException("数字内容暂不可用，请联系管理员");
        }
        if (order.getDigitalContentAccessedAt() == null) {
            order.setDigitalContentAccessedAt(LocalDateTime.now());
            orderInfoMapper.updateById(order);
        }
        return album.getDigitalContentUrl();
    }

    /**
     * 恢复库存（取消订单或超时时调用）
     * 完全重写此方
     */
    private void restoreStock(OrderInfo order) {
        Long albumId = order.getAlbumId();
        Integer quantity = order.getQuantity();
        String orderNo = order.getOrderNo();

        // 获取分布式锁（防止并发恢复）
        String lockKey = LOCK_PREFIX + albumId;
        RLock lock = redissonClient.getLock(lockKey);

        try {
            boolean locked = lock.tryLock(5, TimeUnit.SECONDS);
            if (!locked) {
                throw new BusinessException("系统繁忙，恢复库存失败");
            }

            // 1. 恢复 MySQL 库存
            Album album = albumMapper.selectById(albumId);
            if (album == null) {
                throw new BusinessException("专辑不存在");
            }

            Integer beforeStock = album.getStock();
            Integer afterStock = beforeStock + quantity; // 库存增加

            LambdaUpdateWrapper<Album> updateWrapper = new LambdaUpdateWrapper<>();
            updateWrapper.eq(Album::getId, albumId)
                    .setSql("stock = stock + " + quantity)  // 恢复库存
                    .setSql("sales = sales - " + quantity); // 减少销
            albumMapper.update(null, updateWrapper);

            // 2. 恢复 Redis 库存
            String stockKey = STOCK_PREFIX + albumId;
            if (redisUtil.hasKey(stockKey)) {
                redisUtil.increment(stockKey, quantity); // Redis 库存增加
            }

            // 3. 记录库存流水
            StockLog stockLog = new StockLog();
            stockLog.setAlbumId(albumId);
            stockLog.setOrderNo(orderNo);
            stockLog.setQuantity(quantity);  // 修改：正数（不是负数
            stockLog.setType(2);  // 2-鎭㈠
            stockLog.setBeforeStock(beforeStock);
            stockLog.setAfterStock(afterStock);
            stockLog.setRemark("订单取消或超时后恢复库存");
            stockLog.setCreateTime(LocalDateTime.now());
            stockLogMapper.insert(stockLog);

            log.info("订单 {} 库存恢复成功：{} -> {}", orderNo, beforeStock, afterStock);

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.error("恢复库存时获取锁失败", e);
            throw new BusinessException("恢复库存失败");
        } catch (Exception e) {
            log.error("恢复库存失败：订单号={}", orderNo, e);
            throw new BusinessException("恢复库存失败：" + e.getMessage());
        } finally {
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }

    /**
     * 生成订单
     */
    private String generateOrderNo() {
        return "ORD" + System.currentTimeMillis() + (int)(Math.random() * 10000);
    }

    /**
     * 转换VO
     */
    private OrderVO convertToVO(OrderInfo order) {
        OrderVO vo = new OrderVO();
        BeanUtils.copyProperties(order, vo);

        // 设置状态文
        String statusText = switch (order.getStatus()) {
            case 0 -> "待支付";
            case 1 -> "已支付";
            case 2 -> "已完成";
            case 3 -> "已取消";  // 状态 3 表示已取消
            case 4 -> "已发货";
            default -> "鏈煡";
        };
        vo.setStatusText(statusText);

        return vo;
    }
}