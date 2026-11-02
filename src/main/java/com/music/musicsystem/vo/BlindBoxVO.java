package com.music.musicsystem.vo;


import lombok.Data;

/**
 * 封装接口返回给调用方的展示数据。
 */
@Data
public class BlindBoxVO {

    /**
     * 盲盒ID
     */
    private Long id;

    /**
     * 盲盒名称
     */
    private String name;

    /** 商品展示封面图片地址。 */
    private String coverUrl;

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
    private String price;

    /**
     * 剩余库存
     */
    private Integer remainCount;

    /**
     * 状态：0-下架-上架
     */
    private Integer status;
}
