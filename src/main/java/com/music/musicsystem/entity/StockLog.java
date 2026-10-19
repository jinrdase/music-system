package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */

@Data
@TableName("stock_log")
public class StockLog implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long albumId;

    private Integer quantity;

    private Integer beforeStock;

    private Integer afterStock;

    private String orderNo;

    private Integer type;

    private String remark;

    private LocalDateTime createTime;
}