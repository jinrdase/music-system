package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.music.musicsystem.entity.Album;
import com.music.musicsystem.entity.BlindBox;
import com.music.musicsystem.entity.OrderInfo;
import com.music.musicsystem.entity.SysUser;
import com.music.musicsystem.mapper.AlbumMapper;
import com.music.musicsystem.mapper.BlindBoxMapper;
import com.music.musicsystem.mapper.OrderInfoMapper;
import com.music.musicsystem.mapper.SysUserMapper;
import com.music.musicsystem.service.AdminStatsService;
import com.music.musicsystem.vo.AlbumStatVO;
import com.music.musicsystem.vo.StatsOverviewVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 实现后台运营统计：基于 order_info/sys_user/album/blind_box 现值实时聚合。
 */

@Service
@RequiredArgsConstructor
public class AdminStatsServiceImpl implements AdminStatsService {

    private final OrderInfoMapper orderInfoMapper;
    private final SysUserMapper sysUserMapper;
    private final AlbumMapper albumMapper;
    private final BlindBoxMapper blindBoxMapper;

    /** 库存告警阈值（固定） */
    private static final int LOW_STOCK_THRESHOLD = 10;

    @Override
    public StatsOverviewVO getOverview() {
        LocalDateTime todayStart = LocalDate.now().atStartOfDay();

        StatsOverviewVO vo = new StatsOverviewVO();

        // 今日订单数：今日创建的订单量（含所有状态）
        vo.setTodayOrders(orderInfoMapper.selectCount(
                new LambdaQueryWrapper<OrderInfo>().ge(OrderInfo::getCreateTime, todayStart)));

        // 今日销售额：今日支付且未取消/未退款订单的金额合计。
        // 口径说明：需求文档写 status>=1，但状态 3(已取消) 数值上也 >=1 且从未支付过，
        // 故实现取 status IN (1,2,4)（已支付/已完成/已发货）。
        List<OrderInfo> paidToday = orderInfoMapper.selectList(
                new LambdaQueryWrapper<OrderInfo>()
                        .select(OrderInfo::getTotalAmount)
                        .in(OrderInfo::getStatus,
                                com.music.musicsystem.common.constant.OrderStatus.PAID,
                                com.music.musicsystem.common.constant.OrderStatus.COMPLETED,
                                com.music.musicsystem.common.constant.OrderStatus.SHIPPED)
                        .ge(OrderInfo::getPayTime, todayStart));
        BigDecimal sales = BigDecimal.ZERO;
        for (OrderInfo order : paidToday) {
            if (order.getTotalAmount() != null) {
                sales = sales.add(order.getTotalAmount());
            }
        }
        vo.setTodaySalesAmount(sales);

        vo.setTotalUsers(sysUserMapper.selectCount(null));
        vo.setOnSaleAlbums(albumMapper.selectCount(
                new LambdaQueryWrapper<Album>().eq(Album::getStatus, 1)));
        vo.setLowStockCount(albumMapper.selectCount(
                new LambdaQueryWrapper<Album>()
                        .eq(Album::getStatus, 1)
                        .lt(Album::getStock, LOW_STOCK_THRESHOLD)));

        List<BlindBox> boxes = blindBoxMapper.selectList(
                new LambdaQueryWrapper<BlindBox>().select(BlindBox::getRemainCount));
        int remainTotal = 0;
        for (BlindBox box : boxes) {
            if (box.getRemainCount() != null) {
                remainTotal += box.getRemainCount();
            }
        }
        vo.setBlindBoxRemainTotal(remainTotal);

        return vo;
    }

    @Override
    public List<AlbumStatVO> getAlbumsTop() {
        List<Album> albums = albumMapper.selectList(
                new LambdaQueryWrapper<Album>()
                        .eq(Album::getStatus, 1)
                        .orderByDesc(Album::getSales)
                        .last("LIMIT 10"));
        return albums.stream().map(album -> {
            AlbumStatVO vo = new AlbumStatVO();
            vo.setAlbumId(album.getId());
            vo.setTitle(album.getTitle());
            vo.setArtist(album.getArtist());
            vo.setSales(album.getSales());
            vo.setStock(album.getStock());
            return vo;
        }).toList();
    }
}
