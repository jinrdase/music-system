package com.music.musicsystem.service;

import com.music.musicsystem.vo.AlbumStatVO;
import com.music.musicsystem.vo.StatsOverviewVO;

import java.util.List;

/**
 * 定义后台运营统计查询操作（实时聚合，不建汇总表）。
 */
public interface AdminStatsService {

    /**
     * 运营概览指标：今日订单数/今日销售额/总用户数/在售专辑数/库存告警数/盲盒剩余总库存。
     */
    StatsOverviewVO getOverview();

    /**
     * 专辑销量 TOP10（仅上架专辑，按 sales 倒序）。
     */
    List<AlbumStatVO> getAlbumsTop();
}
