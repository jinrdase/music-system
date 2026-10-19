package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;
import java.math.BigDecimal;

/**
 * 映射业务对象字段与数据库记录。
 */
@Data
@TableName("draw_record")
public class DrawRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 盲盒ID
     */
    private Long boxId;

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

    private BigDecimal probabilityAtDraw;

    /**
     * 当前累计抽数
     */
    private Integer drawCount;

    /**
     * 是否保底-否，1-
     */
    private Integer isGuarantee;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}