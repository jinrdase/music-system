package com.music.musicsystem.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 封装接口返回给调用方的展示数据。
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DrawResultVO {

    /**
     * 抽奖记录列表
     */
    private List<DrawRecordVO> records;

    /**
     * 本次抽取总金额。
     */
    private String totalCost;

    /**
     * 当前累计抽数
     */
    private Integer totalDrawCount;

    /**
     * 距离 SR 保底还差的抽取次数。
     */
    private Integer srRemain;

    /**
     * 距离 SSR 保底还差的抽取次数。
     */
    private Integer ssrRemain;
}