package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.constant.OrderStatus;
import com.music.musicsystem.common.constant.ProductType;
import com.music.musicsystem.dto.BlindBoxOrderDTO;
import com.music.musicsystem.dto.DrawRequestDTO;
import com.music.musicsystem.dto.BlindBoxCreateDTO;
import com.music.musicsystem.dto.BlindBoxPrizeDTO;
import com.music.musicsystem.entity.*;
import com.music.musicsystem.mapper.*;
import com.music.musicsystem.mapper.AlbumMapper;
import com.music.musicsystem.service.IBlindBoxService;
import com.music.musicsystem.vo.BlindBoxVO;
import com.music.musicsystem.vo.DrawRecordVO;
import com.music.musicsystem.vo.DrawResultVO;
import com.music.musicsystem.vo.OrderVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.security.SecureRandom;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import com.music.musicsystem.common.exception.BusinessException;

/**
 * 实现盲盒配置、概率抽取和库存处理业务。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class BlindBoxServiceImpl implements IBlindBoxService {

    private final BlindBoxMapper blindBoxMapper;
    private final AlbumMapper albumMapper;
    private final BlindBoxPrizeMapper prizeMapper;
    private final DrawRecordMapper drawRecordMapper;
    private final UserDrawStatMapper statMapper;
    private final OrderInfoMapper orderInfoMapper;
    private final UserAddressMapper userAddressMapper;
    private final StringRedisTemplate redisTemplate;
    private final RedissonClient redissonClient;

    private static final String STOCK_KEY_PREFIX = "blindbox:stock:";
    private static final String LOCK_KEY_PREFIX = "blindbox:lock:";
    private final SecureRandom secureRandom = new SecureRandom();

    // 保底机制常量。
    private static final int SR_GUARANTEE = 10;   // 10抽保底SR
    private static final int SSR_GUARANTEE = 30;  // 30抽保底SSR

    // 绋€鏈夊害甯搁噺
    private static final int LEVEL_SSR = 1;
    private static final int LEVEL_SR = 2;
    private static final int LEVEL_R = 3;
    private static final int LEVEL_N = 4;
    /**
     * 分页查询后台盲盒列表。
     */

    @Override
    public Page<BlindBoxVO> getAdminBlindBoxList(int pageNum, int pageSize) {
        Page<BlindBox> page = blindBoxMapper.selectPage(new Page<>(pageNum, pageSize),
                new LambdaQueryWrapper<BlindBox>().orderByDesc(BlindBox::getCreateTime));
        Page<BlindBoxVO> result = new Page<>(pageNum, pageSize, page.getTotal());
        result.setRecords(page.getRecords().stream().map(box -> {
            BlindBoxVO vo = new BlindBoxVO();
            BeanUtils.copyProperties(box, vo);
            vo.setPrice(box.getPrice().toPlainString());
            return vo;
        }).toList());
        return result;
    }
    /**
     * 根据管理请求创建盲盒。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createBlindBox(BlindBoxCreateDTO dto) {
        if (albumMapper.selectById(dto.getAlbumId()) == null) {
            throw new BusinessException("关联专辑不存在");
        }
        if (dto.getPrizes().stream().noneMatch(prize -> Integer.valueOf(LEVEL_SSR).equals(prize.getPrizeLevel()))
                || dto.getPrizes().stream().noneMatch(prize -> Integer.valueOf(LEVEL_SR).equals(prize.getPrizeLevel()))) {
            throw new BusinessException("奖品配置必须至少包含SSR和SR，才能满足保底规则");
        }
        if (dto.getPrizes().stream().anyMatch(prize -> prize.getPrizeLevel() < LEVEL_SSR
                || prize.getPrizeLevel() > LEVEL_N)) {
            throw new BusinessException("奖品稀有度只能是1到4");
        }
        BlindBox box = new BlindBox();
        box.setName(dto.getName().trim());
        box.setCoverUrl(dto.getCoverUrl());
        box.setAlbumId(dto.getAlbumId());
        box.setDescription(dto.getDescription());
        box.setPrice(dto.getPrice());
        box.setTotalCount(dto.getTotalCount());
        box.setRemainCount(dto.getTotalCount());
        box.setStatus(0);
        blindBoxMapper.insert(box);

        for (BlindBoxCreateDTO.Prize prizeDTO : dto.getPrizes()) {
            BlindBoxPrize prize = new BlindBoxPrize();
            prize.setBoxId(box.getId());
            prize.setPrizeName(prizeDTO.getPrizeName().trim());
            prize.setPrizeLevel(prizeDTO.getPrizeLevel());
            prize.setProbability(prizeDTO.getProbability());
            prize.setImageUrl(prizeDTO.getImageUrl());
            prize.setDescription(prizeDTO.getDescription());
            prizeMapper.insert(prize);
        }
        return box.getId();
    }
    /**
     * 为指定盲盒添加奖品配置。
     */

    @Override
    public Long addPrize(Long boxId, BlindBoxPrizeDTO dto) {
        BlindBox box = requireInactiveBox(boxId);
        validatePrizeLevel(dto.getPrizeLevel());
        BlindBoxPrize prize = new BlindBoxPrize();
        prize.setBoxId(box.getId());
        copyPrize(dto, prize);
        prizeMapper.insert(prize);
        return prize.getId();
    }
    /**
     * 更新盲盒奖品配置。
     */

    @Override
    public void updatePrize(Long boxId, Long prizeId, BlindBoxPrizeDTO dto) {
        requireInactiveBox(boxId);
        validatePrizeLevel(dto.getPrizeLevel());
        BlindBoxPrize prize = prizeMapper.selectOne(new LambdaQueryWrapper<BlindBoxPrize>()
                .eq(BlindBoxPrize::getId, prizeId)
                .eq(BlindBoxPrize::getBoxId, boxId));
        if (prize == null) {
            throw new BusinessException("奖品不存在");
        }
        copyPrize(dto, prize);
        prizeMapper.updateById(prize);
    }

    private BlindBox requireInactiveBox(Long boxId) {
        BlindBox box = blindBoxMapper.selectById(boxId);
        if (box == null) {
            throw new BusinessException("盲盒不存在");
        }
        if (Integer.valueOf(1).equals(box.getStatus())) {
            throw new BusinessException("请先下架盲盒，再修改奖品配置");
        }
        return box;
    }

    private void validatePrizeLevel(Integer prizeLevel) {
        if (prizeLevel == null || prizeLevel < LEVEL_SSR || prizeLevel > LEVEL_N) {
            throw new BusinessException("奖品稀有度只能是1到4");
        }
    }

    private void copyPrize(BlindBoxPrizeDTO dto, BlindBoxPrize prize) {
        prize.setPrizeName(dto.getPrizeName().trim());
        prize.setPrizeLevel(dto.getPrizeLevel());
        prize.setProbability(dto.getProbability());
        prize.setImageUrl(dto.getImageUrl());
        prize.setDescription(dto.getDescription());
    }
    /**
     * 修改指定盲盒的状态。
     */

    @Override
    public void changeBlindBoxStatus(Long boxId, Integer status) {
        BlindBox box = blindBoxMapper.selectById(boxId);
        if (box == null) {
            throw new BusinessException("盲盒不存在");
        }
        if (status == 1 && box.getRemainCount() <= 0) {
            throw new BusinessException("盲盒库存不足，不能上架");
        }
        if (status == 1) {
            List<BlindBoxPrize> prizes = getPrizeList(boxId);
            boolean hasSsr = prizes.stream().anyMatch(prize -> Integer.valueOf(LEVEL_SSR).equals(prize.getPrizeLevel()));
            boolean hasSr = prizes.stream().anyMatch(prize -> Integer.valueOf(LEVEL_SR).equals(prize.getPrizeLevel()));
            if (!hasSsr || !hasSr) {
                throw new BusinessException("盲盒奖品必须包含SSR和SR才能上架");
            }
        }
        box.setStatus(status);
        blindBoxMapper.updateById(box);
    }

    /**
     * 分页查询盲盒列表
     */
    @Override
    public Page<BlindBoxVO> getBlindBoxList(int pageNum, int pageSize) {
        Page<BlindBox> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<BlindBox> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BlindBox::getStatus, 1); // 只查询上架的盲盒
        wrapper.orderByDesc(BlindBox::getCreateTime);

        Page<BlindBox> blindBoxPage = blindBoxMapper.selectPage(page, wrapper);

        // 转换为VO
        Page<BlindBoxVO> voPage = new Page<>(pageNum, pageSize, blindBoxPage.getTotal());
        List<BlindBoxVO> voList = blindBoxPage.getRecords().stream().map(box -> {
            BlindBoxVO vo = new BlindBoxVO();
            BeanUtils.copyProperties(box, vo);
            vo.setPrice(box.getPrice().toString());
            return vo;
        }).collect(Collectors.toList());

        voPage.setRecords(voList);
        return voPage;
    }

    /**
     * 获取盲盒详情（包含奖品列表）
     */
    @Override
    public BlindBox getBlindBoxDetail(Long boxId) {
        return blindBoxMapper.selectById(boxId);
    }

    /**
     * 获取盲盒的奖品列
     */
    @Override
    public List<BlindBoxPrize> getPrizeList(Long boxId) {
        LambdaQueryWrapper<BlindBoxPrize> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BlindBoxPrize::getBoxId, boxId);
        wrapper.orderByAsc(BlindBoxPrize::getPrizeLevel);
        return prizeMapper.selectList(wrapper);
    }

    /**
     * 核心方法：抽
     *
     * @param userId 用户ID
     * @param request 抽奖请求
     * @return 抽奖结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public DrawResultVO draw(Long userId, DrawRequestDTO request) {
        Long boxId = request.getBoxId();
        Integer drawCount = request.getDrawCount();

        // 1. 参数校验
        if (drawCount == null || (drawCount != 1 && drawCount != 10)) {
            throw new BusinessException("抽奖次数只能是1次或10次");
        }

        // 2. 查询盲盒信息
        BlindBox blindBox = blindBoxMapper.selectById(boxId);
        if (blindBox == null) {
            throw new BusinessException("盲盒不存在");
        }
        if (blindBox.getStatus() != 1) {
            throw new BusinessException("盲盒已下架");
        }

        return doDrawLocked(userId, blindBox, drawCount, true);
    }

    /**
     * 购买盲盒：校验库存与地址后双层扣减库存（Redis 预扣 + MySQL 条件更新，下单即预留），
     * 生成待支付盲盒订单（order_type=2，15 分钟时效）。支付成功后由回调事务内抽取，
     * 不支付则由超时任务取消并回补预留库存。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public OrderVO createBlindBoxOrder(Long userId, BlindBoxOrderDTO dto) {
        Integer drawCount = dto.getDrawCount();
        if (drawCount == null || (drawCount != 1 && drawCount != 10)) {
            throw new BusinessException("抽取次数只能是1次或10次");
        }
        BlindBox box = blindBoxMapper.selectById(dto.getBoxId());
        if (box == null || !Integer.valueOf(1).equals(box.getStatus())) {
            throw new BusinessException("盲盒不存在或已下架");
        }
        if (box.getRemainCount() < drawCount) {
            throw new BusinessException("盲盒库存不足");
        }

        // 奖品为实物周边：必须关联本人收货地址
        UserAddress address = userAddressMapper.selectById(dto.getAddressId());
        if (address == null || address.getDeleted() == 1) {
            throw new BusinessException("收货地址不存在");
        }
        if (!address.getUserId().equals(userId)) {
            throw new BusinessException("无权使用此地址");
        }

        // 用户级分布式锁内执行双层库存扣减（锁粒度：用户+盲盒，与抽取互斥）
        String lockKey = LOCK_KEY_PREFIX + userId + ":" + box.getId();
        RLock lock = redissonClient.getLock(lockKey);
        try {
            boolean locked = lock.tryLock(5, TimeUnit.SECONDS);
            if (!locked) {
                throw new BusinessException("操作过于频繁，请稍后再试");
            }

            String stockKey = STOCK_KEY_PREFIX + box.getId();
            if (!Boolean.TRUE.equals(redisTemplate.hasKey(stockKey))) {
                redisTemplate.opsForValue().set(stockKey, String.valueOf(box.getRemainCount()));
            }
            Long remain = redisTemplate.opsForValue().decrement(stockKey, drawCount);
            if (remain == null || remain < 0) {
                redisTemplate.opsForValue().increment(stockKey, drawCount);
                throw new BusinessException("盲盒库存不足");
            }
            if (blindBoxMapper.deductStock(box.getId(), drawCount) == 0) {
                redisTemplate.opsForValue().increment(stockKey, drawCount);
                throw new BusinessException("盲盒库存不足");
            }

            OrderInfo order = new OrderInfo();
            order.setOrderNo("BB" + System.currentTimeMillis() + (int) (Math.random() * 10000));
            order.setUserId(userId);
            order.setOrderType(2);
            order.setBlindBoxId(box.getId());
            order.setDrawCount(drawCount);
            // album_* 列为旧结构兼容列：album_id 写盲盒关联专辑，标题写盲盒名（真实语义是盲盒订单）
            order.setAlbumId(box.getAlbumId());
            order.setAlbumTitle(box.getName());
            order.setPrice(box.getPrice());
            order.setQuantity(drawCount);
            order.setTotalAmount(box.getPrice().multiply(new BigDecimal(drawCount)));
            order.setStatus(OrderStatus.UNPAID);
            order.setExpireTime(LocalDateTime.now().plusMinutes(15));
            order.setRemark(dto.getRemark());
            order.setProductType(ProductType.PHYSICAL);
            order.setReceiverName(address.getReceiverName());
            order.setReceiverPhone(address.getReceiverPhone());
            order.setReceiverProvince(address.getProvince());
            order.setReceiverCity(address.getCity());
            order.setReceiverDistrict(address.getDistrict());
            order.setReceiverAddress(address.getDetailAddress());
            orderInfoMapper.insert(order);

            log.info("盲盒订单创建成功：订单号={}, 用户={}, 盲盒={}, 抽数={}, 金额={}",
                    order.getOrderNo(), userId, box.getId(), drawCount, order.getTotalAmount());
            return toOrderVO(order);
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
     * 盲盒订单支付成功后的抽取：消耗下单时预留的库存，不再重复扣减。
     * 在支付成功事务内调用（不自带 @Transactional：异常需向上穿透而不标记回滚-only，
     * 由调用方 catch 后执行自动退款）；无订单调用方时由外层事务保证原子性。
     */
    @Override
    public DrawResultVO drawForOrder(OrderInfo order) {
        BlindBox blindBox = blindBoxMapper.selectById(order.getBlindBoxId());
        if (blindBox == null) {
            throw new BusinessException("盲盒不存在，无法执行抽取");
        }
        return doDrawLocked(order.getUserId(), blindBox, order.getDrawCount(), false);
    }

    /**
     * 回补盲盒订单预留的库存（取消/超时/退款/抽取失败自动退款共用）。
     * MySQL 原子自增 + Redis 计数回补，均为原子操作，无需分布式锁。
     */
    @Override
    public void restoreOrderStock(OrderInfo order) {
        Integer count = order.getDrawCount() != null ? order.getDrawCount() : order.getQuantity();
        if (blindBoxMapper.restoreStock(order.getBlindBoxId(), count) == 0) {
            log.warn("盲盒库存回补影响0行：boxId={}, orderNo={}", order.getBlindBoxId(), order.getOrderNo());
        }
        String stockKey = STOCK_KEY_PREFIX + order.getBlindBoxId();
        if (Boolean.TRUE.equals(redisTemplate.hasKey(stockKey))) {
            redisTemplate.opsForValue().increment(stockKey, count);
        }
        log.info("盲盒订单库存回补完成：订单号={}, 盲盒={}, 数量={}", order.getOrderNo(), order.getBlindBoxId(), count);
    }

    /**
     * 抽取核心：用户级分布式锁 → 奖品配置校验 →（deductStock=true 时原子扣库存）→
     * 保底计数 → 逐抽落库（概率快照+是否保底）→ 组装结果。
     */
    private DrawResultVO doDrawLocked(Long userId, BlindBox blindBox, Integer drawCount, boolean deductStock) {
        Long boxId = blindBox.getId();
        String lockKey = LOCK_KEY_PREFIX + userId + ":" + boxId;
        RLock lock = redissonClient.getLock(lockKey);

        try {
            // 尝试获取锁，最多等秒，锁自动释放时0
            boolean locked = lock.tryLock(5, TimeUnit.SECONDS);
            if (!locked) {
                throw new BusinessException("操作过于频繁，请稍后再试");
            }

            // 4. 先校验奖品配置，避免无效配置时扣减库存。
            List<BlindBoxPrize> prizeList = getPrizeList(boxId);
            if (prizeList.isEmpty()) {
                throw new BusinessException("盲盒暂无奖品配置");
            }

            // 5. 独立抽取（无订单预留）时在数据库事务中原子扣减库存；订单支付触发的抽取消耗预留，不再扣减。
            if (deductStock && !checkAndDeductStock(boxId, drawCount)) {
                throw new BusinessException("盲盒库存不足");
            }

            // 6. 获取或初始化用户抽奖统计。
            UserDrawStat stat = getOrCreateUserStat(userId, boxId);

            // 7. 执行抽奖（核心算法）
            List<DrawRecordVO> drawResults = new ArrayList<>();
            for (int i = 0; i < drawCount; i++) {
                // 累加计数
                stat.setTotalCount(stat.getTotalCount() + 1);
                stat.setSrCount(stat.getSrCount() + 1);
                stat.setSsrCount(stat.getSsrCount() + 1);

                // 执行单次抽奖
                DrawRecordVO record = drawOnce(userId, boxId, stat, prizeList);
                drawResults.add(record);

                // 如果抽到SR或SSR，重置对应计
                if (record.getPrizeLevel() == LEVEL_SR) {
                    stat.setSrCount(0);
                } else if (record.getPrizeLevel() == LEVEL_SSR) {
                    stat.setSsrCount(0);
                    stat.setSrCount(0); // SSR同时重置SR计数
                }
            }

            // 8. 更新用户统计
            stat.setLastDrawTime(LocalDateTime.now());
            stat.setUpdateTime(LocalDateTime.now());
            statMapper.updateById(stat);

            // 9. 组装返回结果。
            DrawResultVO result = new DrawResultVO();
            result.setRecords(drawResults);
            result.setTotalCost(blindBox.getPrice().multiply(new BigDecimal(drawCount)).toString());
            result.setTotalDrawCount(stat.getTotalCount());
            result.setSrRemain(SR_GUARANTEE - stat.getSrCount());
            result.setSsrRemain(SSR_GUARANTEE - stat.getSsrCount());

            return result;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new BusinessException("系统繁忙，请稍后再试");
        } finally {
            // 释放
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }

    /**
     * 订单实体转 VO（含状态文案），供盲盒下单返回使用。
     */
    private OrderVO toOrderVO(OrderInfo order) {
        OrderVO vo = new OrderVO();
        BeanUtils.copyProperties(order, vo);
        vo.setStatusText(OrderStatus.toText(order.getStatus()));
        return vo;
    }

    /**
     * 核心算法：单次抽
     *
     * 实现概率抽奖 + 保底机制
     */
    private DrawRecordVO drawOnce(Long userId, Long boxId, UserDrawStat stat, List<BlindBoxPrize> prizeList) {
        BlindBoxPrize selectedPrize;
        boolean isGuarantee = false;

        // 1. 判断是否触发保底
        if (stat.getSsrCount() >= SSR_GUARANTEE) {
            // 触发 SSR 保底。
            selectedPrize = getRandomPrizeByLevel(prizeList, LEVEL_SSR);
            isGuarantee = true;
            log.info("用户{}触发SSR保底，当前SSR计数：{}", userId, stat.getSsrCount());
        } else if (stat.getSrCount() >= SR_GUARANTEE) {
            // 触发 SR 保底。
            selectedPrize = getRandomPrizeByLevel(prizeList, LEVEL_SR);
            isGuarantee = true;
            log.info("用户{}触发SR保底，当前SR计数：{}", userId, stat.getSrCount());
        } else {
            // 正常概率抽奖
            selectedPrize = drawByProbability(prizeList);
        }

        // 2. 保存抽奖记录
        DrawRecord record = new DrawRecord();
        record.setUserId(userId);
        record.setBoxId(boxId);
        record.setPrizeId(selectedPrize.getId());
        record.setPrizeName(selectedPrize.getPrizeName());
        record.setPrizeLevel(selectedPrize.getPrizeLevel());
        record.setProbabilityAtDraw(selectedPrize.getProbability());
        record.setDrawCount(stat.getTotalCount() + 1);
        record.setIsGuarantee(isGuarantee ? 1 : 0);
        record.setCreateTime(LocalDateTime.now());
        drawRecordMapper.insert(record);

        // 3. 转换为VO
        DrawRecordVO vo = new DrawRecordVO();
        vo.setPrizeId(selectedPrize.getId());
        vo.setPrizeName(selectedPrize.getPrizeName());
        vo.setPrizeLevel(selectedPrize.getPrizeLevel());
        vo.setPrizeLevelName(getLevelName(selectedPrize.getPrizeLevel()));
        vo.setImageUrl(selectedPrize.getImageUrl());
        vo.setDescription(selectedPrize.getDescription());
        vo.setIsGuarantee(isGuarantee ? 1 : 0);
        vo.setDrawCount(stat.getTotalCount() + 1);

        return vo;
    }

    /**
     * 核心算法：基于概率的抽奖算法
     *
     * 使用轮盘赌算法（Roulette Wheel Selection
     */
    private BlindBoxPrize drawByProbability(List<BlindBoxPrize> prizeList) {
        // 1. 计算总概
        BigDecimal totalProbability = prizeList.stream()
                .map(BlindBoxPrize::getProbability)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 2. 生成随机数（0-100之间
        double randomValue = secureRandom.nextDouble() * totalProbability.doubleValue();

        // 3. 轮盘赌算法选择奖品
        double cumulativeProbability = 0.0;
        for (BlindBoxPrize prize : prizeList) {
            cumulativeProbability += prize.getProbability().doubleValue();
            if (randomValue <= cumulativeProbability) {
                return prize;
            }
        }

        // 兜底：返回最后一个奖品（理论上不会走到这里）
        return prizeList.get(prizeList.size() - 1);
    }

    /**
     * 根据稀有度随机选择一个奖
     */
    private BlindBoxPrize getRandomPrizeByLevel(List<BlindBoxPrize> prizeList, int level) {
        List<BlindBoxPrize> filteredList = prizeList.stream()
                .filter(p -> p.getPrizeLevel().equals(level))
                .collect(Collectors.toList());

        if (filteredList.isEmpty()) {
            throw new RuntimeException("未找到对应稀有度的奖品");
        }

        return filteredList.get(secureRandom.nextInt(filteredList.size()));
    }

    /**
     * 检查并扣减库存（Redis预扣 + MySQL乐观锁）
     */
    private boolean checkAndDeductStock(Long boxId, Integer count) {
        return blindBoxMapper.deductStock(boxId, count) > 0;
    }

    /**
     * 获取或创建用户抽奖统
     */
    private UserDrawStat getOrCreateUserStat(Long userId, Long boxId) {
        LambdaQueryWrapper<UserDrawStat> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserDrawStat::getUserId, userId);
        wrapper.eq(UserDrawStat::getBoxId, boxId);

        UserDrawStat stat = statMapper.selectOne(wrapper);
        if (stat == null) {
            stat = new UserDrawStat();
            stat.setUserId(userId);
            stat.setBoxId(boxId);
            stat.setTotalCount(0);
            stat.setSrCount(0);
            stat.setSsrCount(0);
            stat.setCreateTime(LocalDateTime.now());
            stat.setUpdateTime(LocalDateTime.now());
            statMapper.insert(stat);
        }

        return stat;
    }

    /**
     * 初始化Redis库存
     */
    @Override
    public void initRedisStock(Long boxId) {
        BlindBox blindBox = blindBoxMapper.selectById(boxId);
        if (blindBox != null) {
            String stockKey = STOCK_KEY_PREFIX + boxId;
            redisTemplate.opsForValue().set(stockKey, String.valueOf(blindBox.getRemainCount()));
            log.info("初始化盲盒{}的Redis库存：{}", boxId, blindBox.getRemainCount());
        }
    }

    /**
     * 查询用户抽奖记录
     */
    @Override
    public Page<DrawRecord> getMyDrawRecords(Long userId, int pageNum, int pageSize) {
        Page<DrawRecord> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<DrawRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(DrawRecord::getUserId, userId);
        wrapper.orderByDesc(DrawRecord::getCreateTime);
        return drawRecordMapper.selectPage(page, wrapper);
    }

    /**
     * 获取稀有度名称
     */
    private String getLevelName(Integer level) {
        switch (level) {
            case LEVEL_SSR: return "SSR";
            case LEVEL_SR: return "SR";
            case LEVEL_R: return "R";
            case LEVEL_N: return "N";
            default: return "鏈煡";
        }
    }
}
