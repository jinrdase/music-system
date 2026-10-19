package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */

@Data
@TableName("shopping_cart")
public class ShoppingCart {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long albumId;

    private String albumName;

    private String albumCover;

    private BigDecimal price;

    private Integer quantity;

    private Integer isSelected; // 0-未选中-已选中

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;
}