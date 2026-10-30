package com.music.musicsystem.vo;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 运营概览指标卡片数据（实时聚合，不建汇总表）。
 */
@Data
public class StatsOverviewVO {

    /** 今日订单数（今日创建的订单量，含所有状态） */
    private Long todayOrders;

    /** 今日销售额（今日支付且未取消/未退款订单的金额合计） */
    private BigDecimal todaySalesAmount;

    /** 总用户数 */
    private Long totalUsers;

    /** 在售专辑数 */
    private Long onSaleAlbums;

    /** 库存告警数（上架且 stock<10 的专辑数，阈值固定 10） */
    private Long lowStockCount;

    /** 盲盒剩余总库存（全部盲盒 remain_count 之和） */
    private Integer blindBoxRemainTotal;
}
