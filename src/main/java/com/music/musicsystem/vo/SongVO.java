package com.music.musicsystem.vo;

import lombok.Data;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class SongVO {

    private Long id;
    private Long albumId;
    private String title;
    private String artist;
    private Integer duration;
    private String previewUrl;
    private Integer previewDuration;
    private Integer trackNumber;
    private Integer playCount;
}