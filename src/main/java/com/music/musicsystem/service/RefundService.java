package com.music.musicsystem.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.dto.RefundDTO;
import com.music.musicsystem.dto.RefundReviewDTO;
import com.music.musicsystem.vo.RefundApplicationVO;

/**
 * 定义退款申请、查询和审核操作。
 */

public interface RefundService {
    /**
     * 提交退款申请。
     */
    RefundApplicationVO apply(Long userId, RefundDTO dto);
    /**
     * 分页查询当前用户的退款申请。
     */
    Page<RefundApplicationVO> getMyApplications(Long userId, Integer current, Integer size);
    /**
     * 分页查询待审核退款申请。
     */
    Page<RefundApplicationVO> getPendingApplications(Integer current, Integer size);
    /**
     * 审核退款申请并处理审核结果。
     */
    void review(Long applicationId, Long auditorId, RefundReviewDTO dto);
}