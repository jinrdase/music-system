package com.music.musicsystem.entity;


import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */
@Data
@TableName("blind_box_prize")
public class BlindBoxPrize {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 盲盒ID
     */
    private Long boxId;

    /**
     * 奖品名称
     */
    private String prizeName;

    /**
     * 稀有度-SSR-SR-R-N
     */
    private Integer prizeLevel;

    /**
     * 基础概率
     */
    private BigDecimal probability;

    /**
     * 奖品图片
     */
    private String imageUrl;

    /**
     * 奖品描述
     */
    private String description;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}