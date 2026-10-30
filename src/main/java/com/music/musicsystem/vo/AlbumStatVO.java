package com.music.musicsystem.vo;

import lombok.Data;

/**
 * 专辑销量榜单条目（TOP N，仅上架专辑）。
 */
@Data
public class AlbumStatVO {

    private Long albumId;

    private String title;

    private String artist;

    /** 累计销量（album.sales） */
    private Integer sales;

    /** 当前库存 */
    private Integer stock;
}
