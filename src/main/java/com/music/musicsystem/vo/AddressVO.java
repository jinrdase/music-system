package com.music.musicsystem.vo;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class AddressVO {
    private Long id;
    private String receiverName;
    private String receiverPhone;
    private String province;
    private String city;
    private String district;
    private String detailAddress;
    private String fullAddress; // 完整地址
    private Integer isDefault;
    private LocalDateTime createTime;
}