package com.music.musicsystem.vo;


import lombok.Data;

/**
 * 封装接口返回给调用方的展示数据。
 */
@Data
public class DrawRecordVO {

    /**
     * 奖品ID
     */
    private Long prizeId;

    /**
     * 奖品名称
     */
    private String prizeName;

    /**
     * 稀有度-SSR-SR-R-N
     */
    private Integer prizeLevel;

    /**
     * 稀有度名称
     */
    private String prizeLevelName;

    /**
     * 奖品图片
     */
    private String imageUrl;

    /**
     * 奖品描述
     */
    private String description;

    /**
     * 是否保底-否，1-
     */
    private Integer isGuarantee;

    /**
     * 当前第几
     */
    private Integer drawCount;
}