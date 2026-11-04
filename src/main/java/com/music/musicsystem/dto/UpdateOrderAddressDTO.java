package com.music.musicsystem.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 待支付订单修改收货地址的请求参数。
 */

@Data
public class UpdateOrderAddressDTO {

    @NotNull(message = "收货地址不能为空")
    private Long addressId;
}
