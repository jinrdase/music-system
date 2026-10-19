package com.music.musicsystem.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.dto.DrawRequestDTO;
import com.music.musicsystem.dto.BlindBoxCreateDTO;
import com.music.musicsystem.dto.BlindBoxPrizeDTO;
import com.music.musicsystem.entity.BlindBox;
import com.music.musicsystem.entity.BlindBoxPrize;
import com.music.musicsystem.entity.DrawRecord;
import com.music.musicsystem.vo.BlindBoxVO;
import com.music.musicsystem.vo.DrawResultVO;

import java.util.List;

/**
 * 定义盲盒查询、后台配置及用户抽取业务操作。
 */
public interface IBlindBoxService {

    /**
     * 分页查询盲盒列表
     */
    Page<BlindBoxVO> getBlindBoxList(int pageNum, int pageSize);

    /**
     * 分页查询后台盲盒列表。
     */
    Page<BlindBoxVO> getAdminBlindBoxList(int pageNum, int pageSize);

    /**
     * 创建盲盒并返回新记录的编号。
     */
    Long createBlindBox(BlindBoxCreateDTO dto);

    /**
     * 修改指定盲盒的状态。
     */
    void changeBlindBoxStatus(Long boxId, Integer status);

    /**
     * 为盲盒添加奖品配置。
     */
    Long addPrize(Long boxId, BlindBoxPrizeDTO dto);

    /**
     * 更新指定奖品配置。
     */
    void updatePrize(Long boxId, Long prizeId, BlindBoxPrizeDTO dto);

    /**
     * 获取盲盒详情
     */
    BlindBox getBlindBoxDetail(Long boxId);

    /**
     * 获取盲盒的奖品列
     */
    List<BlindBoxPrize> getPrizeList(Long boxId);

    /**
     * 抽奖（核心方法）
     */
    DrawResultVO draw(Long userId, DrawRequestDTO request);

    /**
     * 初始化Redis库存
     */
    void initRedisStock(Long boxId);

    /**
     * 查询用户抽奖记录
     */
    Page<DrawRecord> getMyDrawRecords(Long userId, int pageNum, int pageSize);
}