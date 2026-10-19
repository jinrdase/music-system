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
@TableName("blind_box")
public class BlindBox {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 盲盒名称
     */
    private String name;

    /**
     * 关联专辑ID
     */
    private Long albumId;

    /**
     * 描述
     */
    private String description;

    /**
     * 单抽价格
     */
    private BigDecimal price;

    /**
     * 总库
     */
    private Integer totalCount;

    /**
     * 剩余库存
     */
    private Integer remainCount;

    /**
     * 状态：0-下架-上架
     */
    private Integer status;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}