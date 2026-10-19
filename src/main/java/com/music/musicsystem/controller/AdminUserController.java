package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.UserStatusDTO;
import com.music.musicsystem.dto.UserRoleDTO;
import com.music.musicsystem.service.SysUserService;
import com.music.musicsystem.vo.UserVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

/**
 * 处理后台用户状态、角色和列表管理请求。
 */

@RestController
@RequestMapping("/api/admin/users")
public class AdminUserController {

    private final SysUserService sysUserService;

    public AdminUserController(SysUserService sysUserService) {
        this.sysUserService = sysUserService;
    }

    @GetMapping
    public Result<Page<UserVO>> list(@RequestParam(defaultValue = "1") Integer current,
                                     @RequestParam(defaultValue = "10") Integer size,
                                     @RequestParam(required = false) String keyword,
                                     HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(sysUserService.getAdminUserList(current, size, keyword));
    }

    @PutMapping("/{userId}/status")
    public Result<Void> changeStatus(@PathVariable Long userId,
                                     @Valid @RequestBody UserStatusDTO dto,
                                     HttpServletRequest request) {
        String role = requireAdmin(request);
        Long operatorId = (Long) request.getAttribute("userId");
        if (dto.getStatus() != 0 && dto.getStatus() != 1) {
            throw new BusinessException("用户状态只能是0（禁用）或1（启用）");
        }
        sysUserService.changeUserStatus(operatorId, role, userId, dto.getStatus());
        return Result.success("用户状态已更新", null);
    }

    @PutMapping("/{userId}/role")
    public Result<Void> changeRole(@PathVariable Long userId,
                                   @Valid @RequestBody UserRoleDTO dto,
                                   HttpServletRequest request) {
        String role = requireAdmin(request);
        Long operatorId = (Long) request.getAttribute("userId");
        sysUserService.changeUserRole(operatorId, role, userId, dto.getRole());
        return Result.success("用户角色已更新", null);
    }

    private String requireAdmin(HttpServletRequest request) {
        String role = (String) request.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role) && !"super_admin".equalsIgnoreCase(role)) {
            throw new BusinessException(403, "无权执行该操作");
        }
        return role;
    }
}