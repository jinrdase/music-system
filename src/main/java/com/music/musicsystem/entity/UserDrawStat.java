package com.music.musicsystem.entity;


import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */
@Data
@TableName("user_draw_stat")
public class UserDrawStat {

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
     * 累计抽取次数。
     */
    private Integer totalCount;

    /**
     * 距离上次SR的抽
     */
    private Integer srCount;

    /**
     * 距离上次SSR的抽
     */
    private Integer ssrCount;

    /**
     * 最后抽奖时
     */
    private LocalDateTime lastDrawTime;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}