
package com.music.musicsystem.dto;

import lombok.Data;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class CreateOrderDTO {

    @NotNull(message = "专辑ID不能为空")
    private Long albumId;

    /** 实物商品必填；数字商品不需要收货地址。 */
    private Long addressId;

    @NotNull(message = "购买数量不能为空")
    @Min(value = 1, message = "购买数量至少为1")
    private Integer quantity;

    private String remark;
}