package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */

@Data
@TableName("song")
public class Song implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long albumId;

    private String title;

    private String artist;

    private Integer duration;

    private String audioUrl;

    private String previewUrl;

    private Integer previewDuration;

    private Integer trackNumber;

    private String lyrics;

    private Integer playCount;

    @TableLogic
    private Integer deleted;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}