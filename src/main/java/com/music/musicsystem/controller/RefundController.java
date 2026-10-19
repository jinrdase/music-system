package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.RefundDTO;
import com.music.musicsystem.dto.RefundReviewDTO;
import com.music.musicsystem.service.RefundService;
import com.music.musicsystem.vo.RefundApplicationVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

/**
 * 处理用户退款申请及后台退款审核请求。
 */

@RestController
@RequestMapping("/api/refund")
public class RefundController {

    private final RefundService refundService;

    public RefundController(RefundService refundService) {
        this.refundService = refundService;
    }

    @PostMapping("/apply")
    public Result<RefundApplicationVO> apply(@Valid @RequestBody RefundDTO dto,
                                              HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(refundService.apply(userId, dto));
    }

    @GetMapping("/my")
    public Result<Page<RefundApplicationVO>> getMyApplications(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(refundService.getMyApplications(userId, current, size));
    }

    @GetMapping("/admin/pending")
    public Result<Page<RefundApplicationVO>> getPendingApplications(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(refundService.getPendingApplications(current, size));
    }

    @PutMapping("/admin/{applicationId}/review")
    public Result<Void> review(@PathVariable Long applicationId,
                               @Valid @RequestBody RefundReviewDTO dto,
                               HttpServletRequest request) {
        requireAdmin(request);
        Long auditorId = (Long) request.getAttribute("userId");
        refundService.review(applicationId, auditorId, dto);
        return Result.success("退款申请审核完成", null);
    }

    private void requireAdmin(HttpServletRequest request) {
        String role = (String) request.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role) && !"super_admin".equalsIgnoreCase(role)) {
            throw new BusinessException(403, "无权执行该操作");
        }
    }
}