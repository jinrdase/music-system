package com.music.musicsystem.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class AlbumVO {

    private Long id;
    private String title;
    private String artist;
    private String coverUrl;
    private String description;
    private String productType;
    private LocalDate releaseDate;
    private BigDecimal price;
    private Integer stock;
    private Integer sales;
    private Integer status;
    private Integer isLimited;
}