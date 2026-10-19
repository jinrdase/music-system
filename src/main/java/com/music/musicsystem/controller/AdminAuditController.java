package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.entity.AdminAuditLog;
import com.music.musicsystem.mapper.AdminAuditLogMapper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 处理后台操作审计记录的查询请求。
 */

@RestController
@RequestMapping("/api/admin/audit-logs")
@RequiredArgsConstructor
public class AdminAuditController {
    private final AdminAuditLogMapper auditLogMapper;

    @GetMapping
    public Result<Page<AdminAuditLog>> list(@RequestParam(defaultValue = "1") long current,
                                             @RequestParam(defaultValue = "20") long size,
                                             HttpServletRequest request) {
        if (!"super_admin".equalsIgnoreCase((String) request.getAttribute("role"))) {
            throw new BusinessException(403, "只有超级管理员可以查看操作审计");
        }
        long safeSize = Math.min(Math.max(size, 1), 100);
        Page<AdminAuditLog> page = auditLogMapper.selectPage(new Page<>(Math.max(current, 1), safeSize),
                new LambdaQueryWrapper<AdminAuditLog>().orderByDesc(AdminAuditLog::getCreatedAt));
        return Result.success(page);
    }
}