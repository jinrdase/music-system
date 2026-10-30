package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.impl.ServiceImpl;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.constant.OrderStatus;
import com.music.musicsystem.common.constant.PaymentStatus;
import com.music.musicsystem.common.constant.ProductType;
import com.music.musicsystem.common.constant.RefundStatus;
import com.music.musicsystem.dto.CreateFromCartDTO;
import com.music.musicsystem.dto.CreateOrderDTO;
import com.music.musicsystem.dto.ShipOrderDTO;
import com.music.musicsystem.entity.Album;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.entity.OrderItem;
import com.music.musicsystem.entity.OrderLogistics;
import com.music.musicsystem.entity.Payment;
import com.music.musicsystem.entity.RefundApplication;
import com.music.musicsystem.entity.ShoppingCart;
import com.music.musicsystem.entity.StockLog;
import com.music.musicsystem.entity.SysUser;
import com.music.musicsystem.entity.UserAddress;
import com.music.musicsystem.mapper.AlbumMapper;
import com.music.musicsystem.mapper.OrderInfoMapper;
import com.music.musicsystem.mapper.OrderItemMapper;
import com.music.musicsystem.mapper.OrderLogisticsMapper;
import com.music.musicsystem.mapper.PaymentMapper;
import com.music.musicsystem.mapper.RefundApplicationMapper;
import com.music.musicsystem.mapper.ShoppingCartMapper;
import com.music.musicsystem.mapper.StockLogMapper;
import com.music.musicsystem.mapper.SysUserMapper;
import com.music.musicsystem.mapper.UserAddressMapper;
import com.music.musicsystem.service.IBlindBoxService;
import com.music.musicsystem.service.OrderService;
import com.music.musicsystem.util.RedisUtil;
import com.music.musicsystem.vo.AdminOrderVO;
import com.music.musicsystem.vo.DrawResultVO;
import com.music.musicsystem.vo.OrderItemVO;
import com.music.musicsystem.vo.OrderVO;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
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
    private OrderItemMapper orderItemMapper;

    @Autowired
    private ShoppingCartMapper shoppingCartMapper;

    @Autowired
    private PaymentMapper paymentMapper;

    @Autowired
    private IBlindBoxService blindBoxService;

    @Autowired
    private SysUserMapper sysUserMapper;


    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private RedissonClient redissonClient;

    private static final String STOCK_PREFIX = "album:stock:";
    private static final String LOCK_PREFIX = "album:lock:";
    /**
     * 在支付成功后推进订单及相关业务状态。
     * 条件更新 status: 0→1（重复回调时已支付订单直接返回，保证幂等）；
     * 盲盒订单（order_type=2）在同事务内抽取：消耗下单预留库存、写抽取记录与保底计数、
     * 结果摘要回写订单；抽取失败自动退款（订单/支付单置已退款、回补盲盒库存），不吞钱。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void handlePaymentSuccess(Long orderId) {
        OrderInfo order = orderInfoMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException("订单不存在");
        }

        // 条件更新为已支付（幂等：重复回调影响 0 行直接返回，不重复抽取）
        int updated = orderInfoMapper.update(
                null,
                new LambdaUpdateWrapper<OrderInfo>()
                        .eq(OrderInfo::getId, order.getId())
                        .eq(OrderInfo::getStatus, OrderStatus.UNPAID)
                        .set(OrderInfo::getStatus, OrderStatus.PAID)
                        .set(OrderInfo::getPayTime, LocalDateTime.now())
        );
        if (updated == 0) {
            log.info("订单 {} 已推进过支付状态，跳过重复回调", order.getOrderNo());
            return;
        }

        // 盲盒订单：支付即抽取
        if (order.getOrderType() != null && order.getOrderType() == 2) {
            try {
                DrawResultVO drawResult = blindBoxService.drawForOrder(order);
                String summary = drawResult.getRecords().stream()
                        .map(r -> r.getPrizeLevelName() + "·" + r.getPrizeName())
                        .collect(Collectors.joining("、"));
                orderInfoMapper.update(
                        null,
                        new LambdaUpdateWrapper<OrderInfo>()
                                .eq(OrderInfo::getId, order.getId())
                                .set(OrderInfo::getDrawSummary, summary)
                );
                log.info("盲盒订单抽取完成：订单号={}, 结果={}", order.getOrderNo(), summary);
            } catch (Exception e) {
                // 抽取失败不吞钱：同事务内自动退款并回补盲盒预留库存
                log.error("盲盒订单抽取失败，自动退款：订单号={}", order.getOrderNo(), e);
                autoRefundBlindBoxOrder(order, e.getMessage());
            }
        }

        // TODO: 发送支付成功通知（短站内信）
    }

    /**
     * 盲盒订单抽取失败后的自动退款：订单置已退款(5)、支付单置已退款(3)、回补盲盒库存。
     * 与支付回调同事务，调用方对渠道返回成功，避免渠道重复通知。
     */
    private void autoRefundBlindBoxOrder(OrderInfo order, String reason) {
        orderInfoMapper.update(
                null,
                new LambdaUpdateWrapper<OrderInfo>()
                        .eq(OrderInfo::getId, order.getId())
                        .eq(OrderInfo::getStatus, OrderStatus.PAID)
                        .set(OrderInfo::getStatus, OrderStatus.REFUNDED)
                        .set(OrderInfo::getDrawSummary, "抽取失败自动退款：" + reason)
        );
        paymentMapper.update(
                null,
                new LambdaUpdateWrapper<Payment>()
                        .eq(Payment::getOrderId, order.getId())
                        .eq(Payment::getStatus, PaymentStatus.SUCCESS)
                        .set(Payment::getStatus, PaymentStatus.REFUNDED)
        );
        blindBoxService.restoreOrderStock(order);
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

            // 7. 创建订单（单商品直购：内部生成单明细订单）
            OrderInfo order = new OrderInfo();
            order.setOrderNo(generateOrderNo());
            order.setUserId(userId);
            order.setOrderType(1);
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

            // 7.1 单明细：直购订单只有一条 order_item，与合并结算订单共用结构
            OrderItem item = new OrderItem();
            item.setOrderId(order.getId());
            item.setOrderNo(order.getOrderNo());
            item.setAlbumId(albumId);
            item.setAlbumTitle(album.getTitle());
            item.setAlbumCover(album.getCoverUrl());
            item.setPrice(album.getPrice());
            item.setQuantity(quantity);
            item.setSubtotal(album.getPrice().multiply(new BigDecimal(quantity)));
            item.setProductType(album.getProductType());
            orderItemMapper.insert(item);

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
     * 购物车合并结算：已勾选商品合并为一张多明细订单。
     * 整单拒绝策略：任一明细失效/缺货则整单失败；中途扣减失败时事务回滚 MySQL 库存、
     * 手动回补 Redis 预扣，保证两层库存一致。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public OrderVO createFromCart(Long userId, CreateFromCartDTO dto) {
        // 1. 汇总已勾选商品
        List<ShoppingCart> carts = shoppingCartMapper.selectList(
                new LambdaQueryWrapper<ShoppingCart>()
                        .eq(ShoppingCart::getUserId, userId)
                        .eq(ShoppingCart::getIsSelected, 1)
                        .orderByDesc(ShoppingCart::getCreateTime)
        );
        if (carts.isEmpty()) {
            throw new BusinessException("请先勾选要结算的商品");
        }

        // 2. 逐项校验：专辑在售、库存充足（整单拒绝）
        Map<Long, Album> albums = new LinkedHashMap<>();
        boolean hasPhysical = false;
        for (ShoppingCart cart : carts) {
            Album album = albumMapper.selectById(cart.getAlbumId());
            if (album == null || album.getStatus() != 1) {
                throw new BusinessException("商品「" + cart.getAlbumName() + "」已失效，请清理后再结算");
            }
            if (album.getStock() < cart.getQuantity()) {
                throw new BusinessException("商品「" + album.getTitle() + "」库存不足，剩余 " + album.getStock() + " 件");
            }
            albums.put(cart.getAlbumId(), album);
            if (ProductType.isPhysical(album.getProductType())) {
                hasPhysical = true;
            }
        }

        // 3. 地址规则：含实物明细必须传本人地址；全数字明细不传地址
        UserAddress address = null;
        if (hasPhysical) {
            if (dto.getAddressId() == null) {
                throw new BusinessException("结算包含实物商品，必须选择收货地址");
            }
            address = userAddressMapper.selectById(dto.getAddressId());
            if (address == null || address.getDeleted() == 1) {
                throw new BusinessException("收货地址不存在");
            }
            if (!address.getUserId().equals(userId)) {
                throw new BusinessException("无权使用此地址");
            }
        } else if (dto.getAddressId() != null) {
            throw new BusinessException("数字商品无需填写收货地址");
        }

        // 4. 逐明细双层库存扣减（订单号提前生成供库存流水使用）
        String orderNo = generateOrderNo();
        Map<Long, Integer> deducted = new LinkedHashMap<>();
        try {
            for (ShoppingCart cart : carts) {
                deductAlbumStock(albums.get(cart.getAlbumId()), cart.getQuantity(), orderNo, deducted);
            }

            // 5. 订单主表（album_* 列写首件快照，仅供旧列表展示；真实明细在 order_item）
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (ShoppingCart cart : carts) {
                totalAmount = totalAmount.add(albums.get(cart.getAlbumId()).getPrice()
                        .multiply(new BigDecimal(cart.getQuantity())));
            }
            Album first = albums.get(carts.get(0).getAlbumId());
            OrderInfo order = new OrderInfo();
            order.setOrderNo(orderNo);
            order.setUserId(userId);
            order.setOrderType(1);
            order.setAlbumId(first.getId());
            order.setAlbumTitle(first.getTitle());
            order.setAlbumCover(first.getCoverUrl());
            order.setPrice(first.getPrice());
            order.setQuantity(carts.get(0).getQuantity());
            order.setTotalAmount(totalAmount);
            order.setStatus(OrderStatus.UNPAID);
            order.setExpireTime(LocalDateTime.now().plusMinutes(15));
            order.setRemark(dto.getRemark());
            order.setProductType(hasPhysical ? ProductType.PHYSICAL : ProductType.DIGITAL);
            if (address != null) {
                order.setReceiverName(address.getReceiverName());
                order.setReceiverPhone(address.getReceiverPhone());
                order.setReceiverProvince(address.getProvince());
                order.setReceiverCity(address.getCity());
                order.setReceiverDistrict(address.getDistrict());
                order.setReceiverAddress(address.getDetailAddress());
            }
            this.save(order);

            // 6. 写订单明细
            for (ShoppingCart cart : carts) {
                Album album = albums.get(cart.getAlbumId());
                OrderItem item = new OrderItem();
                item.setOrderId(order.getId());
                item.setOrderNo(orderNo);
                item.setAlbumId(album.getId());
                item.setAlbumTitle(album.getTitle());
                item.setAlbumCover(album.getCoverUrl());
                item.setPrice(album.getPrice());
                item.setQuantity(cart.getQuantity());
                item.setSubtotal(album.getPrice().multiply(new BigDecimal(cart.getQuantity())));
                item.setProductType(album.getProductType());
                orderItemMapper.insert(item);
            }

            // 7. 移除已结算的购物车项（逻辑删除）
            for (ShoppingCart cart : carts) {
                shoppingCartMapper.deleteById(cart.getId());
            }

            log.info("购物车结算成功：订单号={}, 用户ID={}, 明细数={}, 总金额={}",
                    orderNo, userId, carts.size(), totalAmount);
            return convertToVO(order);

        } catch (BusinessException e) {
            compensateRedisStock(deducted);
            throw e;
        } catch (Exception e) {
            log.error("购物车结算失败：用户ID={}", userId, e);
            compensateRedisStock(deducted);
            throw new BusinessException("结算失败：" + e.getMessage());
        }
    }

    /**
     * 单张专辑的双层库存扣减（Redis 预扣 + MySQL 条件更新），成功后记入 deducted 供失败补偿。
     */
    private void deductAlbumStock(Album album, Integer quantity, String orderNo, Map<Long, Integer> deducted) {
        Long albumId = album.getId();
        RLock lock = redissonClient.getLock(LOCK_PREFIX + albumId);
        try {
            boolean locked = lock.tryLock(5, 10, TimeUnit.SECONDS);
            if (!locked) {
                throw new BusinessException("系统繁忙，请稍后再试");
            }
            String stockKey = STOCK_PREFIX + albumId;
            if (!redisUtil.hasKey(stockKey)) {
                redisUtil.set(stockKey, album.getStock());
            }
            Long remainStock = redisUtil.decrement(stockKey, quantity);
            if (remainStock < 0) {
                redisUtil.increment(stockKey, quantity);
                throw new BusinessException("库存不足");
            }

            LambdaUpdateWrapper<Album> updateWrapper = new LambdaUpdateWrapper<>();
            updateWrapper.eq(Album::getId, albumId)
                    .ge(Album::getStock, quantity)
                    .setSql("stock = stock - " + quantity)
                    .setSql("sales = sales + " + quantity);
            if (albumMapper.update(null, updateWrapper) == 0) {
                redisUtil.increment(stockKey, quantity);
                throw new BusinessException("库存不足或库存已被占用");
            }

            deducted.merge(albumId, quantity, Integer::sum);

            Album updatedAlbum = albumMapper.selectById(albumId);
            StockLog stockLog = new StockLog();
            stockLog.setAlbumId(albumId);
            stockLog.setOrderNo(orderNo);
            stockLog.setQuantity(quantity);
            stockLog.setBeforeStock(updatedAlbum.getStock() + quantity);
            stockLog.setAfterStock(updatedAlbum.getStock());
            stockLog.setType(1);
            stockLog.setRemark("用户下单扣减库存");
            stockLogMapper.insert(stockLog);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new BusinessException("系统繁忙，请稍后再试");
        } finally {
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }

    /**
     * 结算失败时回补 Redis 预扣库存（MySQL 部分由事务回滚恢复）。
     */
    private void compensateRedisStock(Map<Long, Integer> deducted) {
        for (Map.Entry<Long, Integer> entry : deducted.entrySet()) {
            String stockKey = STOCK_PREFIX + entry.getKey();
            if (redisUtil.hasKey(stockKey)) {
                redisUtil.increment(stockKey, entry.getValue());
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
        if (!OrderStatus.UNPAID.equals(order.getStatus())) {
            throw new BusinessException("只能取消待支付订单");
        }

        // 2. 条件更新订单状态为已取消（WHERE status=0 防并发重复取消/重复回补库存）
        int updated = orderInfoMapper.update(
                null,
                new LambdaUpdateWrapper<OrderInfo>()
                        .eq(OrderInfo::getId, order.getId())
                        .eq(OrderInfo::getStatus, OrderStatus.UNPAID)
                        .set(OrderInfo::getStatus, OrderStatus.CANCELLED)
                        .set(OrderInfo::getCancelTime, LocalDateTime.now())
        );
        if (updated == 0) {
            throw new BusinessException("订单状态已变化，请刷新后重试");
        }

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
        vo.setItems(buildItemVOs(order));
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
     * 查询订单明细。订单所有者或管理员可查；无明细的历史订单按订单级字段合成单条返回。
     */
    @Override
    public List<OrderItemVO> getOrderItems(Long userId, String orderNo, boolean isAdmin) {
        OrderInfo order = requireOrder(orderNo, userId, isAdmin);
        return buildItemVOs(order);
    }

    /**
     * 明细级数字内容取阅：校验订单归属与支付状态、明细为数字形态，
     * FOR UPDATE 行锁下记录首次取阅时间（明细级退款闸门）后返回内容地址。
     * 无明细的历史订单回退为订单级处理。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public String getDigitalContentByItem(Long userId, String orderNo, Long itemId) {
        OrderInfo order = orderInfoMapper.selectOne(new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getOrderNo, orderNo)
                .eq(OrderInfo::getUserId, userId));
        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        if (!OrderStatus.PAID.equals(order.getStatus()) && !OrderStatus.COMPLETED.equals(order.getStatus())) {
            throw new BusinessException("订单支付完成后才能获取数字内容");
        }

        List<OrderItem> items = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, order.getId()));
        if (items.isEmpty()) {
            // 历史单商品订单：按订单级字段处理（复用旧取阅逻辑）
            return getDigitalContent(userId, orderNo);
        }

        OrderItem item = items.stream()
                .filter(i -> i.getId().equals(itemId))
                .findFirst()
                .orElseThrow(() -> new BusinessException("订单明细不存在"));
        if (!ProductType.isDigital(item.getProductType())) {
            throw new BusinessException("该明细不是数字商品");
        }

        OrderItem locked = orderItemMapper.selectOne(new LambdaQueryWrapper<OrderItem>()
                .eq(OrderItem::getId, item.getId())
                .last("FOR UPDATE"));
        Album album = albumMapper.selectById(item.getAlbumId());
        if (album == null || album.getDigitalContentUrl() == null || album.getDigitalContentUrl().isBlank()) {
            throw new BusinessException("数字内容暂不可用，请联系管理员");
        }
        if (locked.getDigitalContentAccessedAt() == null) {
            locked.setDigitalContentAccessedAt(LocalDateTime.now());
            orderItemMapper.updateById(locked);
        }
        return album.getDigitalContentUrl();
    }

    /**
     * 按订单号查订单；isAdmin=false 时强校验归属，true 时由调用方（Controller）保证管理员权限。
     */
    private OrderInfo requireOrder(String orderNo, Long userId, boolean isAdmin) {
        LambdaQueryWrapper<OrderInfo> query = new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getOrderNo, orderNo);
        if (!isAdmin) {
            query.eq(OrderInfo::getUserId, userId);
        }
        OrderInfo order = this.getOne(query);
        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        return order;
    }

    /**
     * 组装订单明细 VO：多明细订单读 order_item；历史单商品订单按订单级字段合成一条。
     */
    private List<OrderItemVO> buildItemVOs(OrderInfo order) {
        List<OrderItem> items = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>()
                        .eq(OrderItem::getOrderId, order.getId())
                        .orderByAsc(OrderItem::getId));
        List<OrderItemVO> vos = new ArrayList<>();
        if (items.isEmpty()) {
            OrderItemVO vo = new OrderItemVO();
            vo.setOrderId(order.getId());
            vo.setOrderNo(order.getOrderNo());
            vo.setAlbumId(order.getAlbumId());
            vo.setAlbumTitle(order.getAlbumTitle());
            vo.setAlbumCover(order.getAlbumCover());
            vo.setPrice(order.getPrice());
            vo.setQuantity(order.getQuantity());
            vo.setSubtotal(order.getPrice() == null ? null
                    : order.getPrice().multiply(new BigDecimal(order.getQuantity())));
            vo.setProductType(order.getProductType());
            vo.setProductTypeText(ProductType.isDigital(order.getProductType()) ? "数字" : "实物");
            vo.setDigitalContentAccessedAt(order.getDigitalContentAccessedAt());
            vos.add(vo);
            return vos;
        }
        for (OrderItem item : items) {
            OrderItemVO vo = new OrderItemVO();
            BeanUtils.copyProperties(item, vo);
            vo.setProductTypeText(ProductType.isDigital(item.getProductType()) ? "数字" : "实物");
            vos.add(vo);
        }
        return vos;
    }

    /**
     * 后台订单列表：分页 + 状态/订单号/用户ID/创建时间范围筛选，按创建时间倒序，批量补充用户名。
     * 只读接口，不提供任何状态修改。
     */
    @Override
    public Page<AdminOrderVO> getAdminOrders(Integer current, Integer size, Integer status,
                                             String orderNo, Long userId, String startDate, String endDate) {
        LambdaQueryWrapper<OrderInfo> query = new LambdaQueryWrapper<>();
        if (status != null) {
            query.eq(OrderInfo::getStatus, status);
        }
        if (orderNo != null && !orderNo.isBlank()) {
            query.eq(OrderInfo::getOrderNo, orderNo.trim());
        }
        if (userId != null) {
            query.eq(OrderInfo::getUserId, userId);
        }
        DateTimeFormatter datePattern = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        try {
            if (startDate != null && !startDate.isBlank()) {
                query.ge(OrderInfo::getCreateTime, LocalDate.parse(startDate.trim(), datePattern).atStartOfDay());
            }
            if (endDate != null && !endDate.isBlank()) {
                query.le(OrderInfo::getCreateTime, LocalDate.parse(endDate.trim(), datePattern).atTime(LocalTime.MAX));
            }
        } catch (DateTimeParseException e) {
            throw new BusinessException("日期格式不正确，应为 yyyy-MM-dd");
        }
        query.orderByDesc(OrderInfo::getCreateTime);

        Page<OrderInfo> page = this.page(new Page<>(current, size), query);

        // 批量补充用户名（避免逐行查询）
        Map<Long, String> usernames = new HashMap<>();
        List<Long> userIds = page.getRecords().stream().map(OrderInfo::getUserId).distinct().toList();
        if (!userIds.isEmpty()) {
            for (SysUser user : sysUserMapper.selectBatchIds(userIds)) {
                usernames.put(user.getId(), user.getUsername());
            }
        }

        Page<AdminOrderVO> result = new Page<>(current, size, page.getTotal());
        result.setRecords(page.getRecords().stream().map(order -> {
            AdminOrderVO vo = new AdminOrderVO();
            BeanUtils.copyProperties(order, vo);
            vo.setStatusText(OrderStatus.toText(order.getStatus()));
            vo.setUsername(usernames.get(order.getUserId()));
            return vo;
        }).collect(Collectors.toList()));
        return result;
    }

    /**
     * 恢复库存（取消订单、超时关单、退款执行共用）。
     * 盲盒订单（order_type=2）走盲盒库存回补；专辑订单按 order_item 逐条回补；
     * 无明细的历史订单按订单级快照回补。
     */
    @Override
    public void restoreStock(OrderInfo order) {
        if (order.getOrderType() != null && order.getOrderType() == 2) {
            blindBoxService.restoreOrderStock(order);
            return;
        }
        List<OrderItem> items = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, order.getId()));
        if (!items.isEmpty()) {
            for (OrderItem item : items) {
                restoreAlbumStock(item.getAlbumId(), item.getQuantity(), order.getOrderNo());
            }
            return;
        }
        restoreAlbumStock(order.getAlbumId(), order.getQuantity(), order.getOrderNo());
    }

    /**
     * 按专辑回补库存：MySQL 库存/销量回补、Redis 预扣回补、写 type=2 库存流水。
     */
    private void restoreAlbumStock(Long albumId, Integer quantity, String orderNo) {

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
        vo.setStatusText(OrderStatus.toText(order.getStatus()));
        return vo;
    }
}