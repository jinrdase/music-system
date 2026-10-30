package com.music.musicsystem.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 购买盲盒入参：生成待支付的盲盒订单（order_type=2）。
 */
@Data
public class BlindBoxOrderDTO {

    @NotNull(message = "盲盒ID不能为空")
    private Long boxId;

    /** 抽取次数：1-单抽，10-十连 */
    @NotNull(message = "抽取次数不能为空")
    private Integer drawCount;

    /** 盲盒奖品为实物周边，必须选择收货地址 */
    @NotNull(message = "购买盲盒必须选择收货地址")
    private Long addressId;

    private String remark;
}
