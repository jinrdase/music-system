package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.BlindBoxCreateDTO;
import com.music.musicsystem.dto.BlindBoxPrizeDTO;
import com.music.musicsystem.service.IBlindBoxService;
import com.music.musicsystem.vo.BlindBoxVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

/**
 * 处理后台盲盒及奖品配置管理请求。
 */

@RestController
@RequestMapping("/api/admin/blind-boxes")
public class AdminBlindBoxController {

    private final IBlindBoxService blindBoxService;

    public AdminBlindBoxController(IBlindBoxService blindBoxService) {
        this.blindBoxService = blindBoxService;
    }

    @GetMapping
    public Result<Page<BlindBoxVO>> list(@RequestParam(defaultValue = "1") Integer current,
                                         @RequestParam(defaultValue = "10") Integer size,
                                         HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(blindBoxService.getAdminBlindBoxList(current, size));
    }

    @PostMapping
    public Result<Long> create(@Valid @RequestBody BlindBoxCreateDTO dto,
                               HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(blindBoxService.createBlindBox(dto));
    }

    @PutMapping("/{boxId}/status")
    public Result<Void> changeStatus(@PathVariable Long boxId,
                                     @RequestParam Integer status,
                                     HttpServletRequest request) {
        requireAdmin(request);
        if (status == null || (status != 0 && status != 1)) {
            throw new BusinessException("盲盒状态只能是0（下架）或1（上架）");
        }
        blindBoxService.changeBlindBoxStatus(boxId, status);
        return Result.success("盲盒状态已更新", null);
    }

    @PostMapping("/{boxId}/prizes")
    public Result<Long> addPrize(@PathVariable Long boxId,
                                 @Valid @RequestBody BlindBoxPrizeDTO dto,
                                 HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(blindBoxService.addPrize(boxId, dto));
    }

    @PutMapping("/{boxId}/prizes/{prizeId}")
    public Result<Void> updatePrize(@PathVariable Long boxId,
                                    @PathVariable Long prizeId,
                                    @Valid @RequestBody BlindBoxPrizeDTO dto,
                                    HttpServletRequest request) {
        requireAdmin(request);
        blindBoxService.updatePrize(boxId, prizeId, dto);
        return Result.success("奖品配置已更新", null);
    }

    private void requireAdmin(HttpServletRequest request) {
        String role = (String) request.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role) && !"super_admin".equalsIgnoreCase(role)) {
            throw new BusinessException(403, "无权执行该操作");
        }
    }
}