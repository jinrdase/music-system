package com.music.musicsystem.controller;

import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.service.AdminStatsService;
import com.music.musicsystem.vo.AlbumStatVO;
import com.music.musicsystem.vo.StatsOverviewVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 后台运营统计：概览指标卡片与专辑销量 TOP 榜单。
 */

@RestController
@RequestMapping("/api/admin/stats")
public class AdminStatsController {

    private final AdminStatsService adminStatsService;

    public AdminStatsController(AdminStatsService adminStatsService) {
        this.adminStatsService = adminStatsService;
    }

    @GetMapping("/overview")
    public Result<StatsOverviewVO> overview(HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(adminStatsService.getOverview());
    }

    @GetMapping("/albums-top")
    public Result<List<AlbumStatVO>> albumsTop(HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(adminStatsService.getAlbumsTop());
    }

    private void requireAdmin(HttpServletRequest request) {
        String role = (String) request.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role) && !"super_admin".equalsIgnoreCase(role)) {
            throw new BusinessException(403, "无权执行该操作");
        }
    }
}
