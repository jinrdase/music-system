package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */

@Data
@TableName("album")
public class Album implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;

    private String artist;

    private String coverUrl;

    private String description;

    /** 商品形态：PHYSICAL（实物）或 DIGITAL（数字内容）。 */
    private String productType;

    /** 数字商品的受控内容地址；只允许已支付订单所有者通过订单接口获取。 */
    private String digitalContentUrl;

    private LocalDate releaseDate;

    private BigDecimal price;

    private Integer stock;

    private Integer sales;

    private Integer status;

    private Integer isLimited;

    @TableLogic
    private Integer deleted;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}