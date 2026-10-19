package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.entity.BlindBox;
import com.music.musicsystem.entity.BlindBoxPrize;
import com.music.musicsystem.service.IBlindBoxService;
import com.music.musicsystem.vo.BlindBoxDetailVO;
import com.music.musicsystem.vo.BlindBoxVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 处理面向用户的盲盒查询与抽取请求。
 */

@RestController
@RequestMapping("/api/blind-box")
public class BlindBoxController {

    private final IBlindBoxService blindBoxService;

    public BlindBoxController(IBlindBoxService blindBoxService) {
        this.blindBoxService = blindBoxService;
    }

    @GetMapping("/list")
    public Result<Page<BlindBoxVO>> list(@RequestParam(defaultValue = "1") Integer current,
                                         @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(blindBoxService.getBlindBoxList(current, size));
    }
    /**
     * 查询盲盒详情并返回接口响应。
     */

    @GetMapping("/{boxId}")
    public Result<BlindBoxDetailVO> detail(@PathVariable Long boxId) {
        BlindBox box = blindBoxService.getBlindBoxDetail(boxId);
        if (box == null || !Integer.valueOf(1).equals(box.getStatus())) {
            throw new BusinessException("盲盒不存在或已下架");
        }
        BlindBoxVO boxVO = new BlindBoxVO();
        BeanUtils.copyProperties(box, boxVO);
        boxVO.setPrice(box.getPrice().toPlainString());
        BlindBoxDetailVO detail = new BlindBoxDetailVO();
        detail.setBlindBox(boxVO);
        detail.setPrizes(blindBoxService.getPrizeList(boxId));
        return Result.success(detail);
    }

    @GetMapping("/my/records")
    public Result<Page<com.music.musicsystem.entity.DrawRecord>> myRecords(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(blindBoxService.getMyDrawRecords(userId, current, size));
    }
}