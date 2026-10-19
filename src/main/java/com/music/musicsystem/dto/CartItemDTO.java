
package com.music.musicsystem.dto;

import lombok.Data;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class CartItemDTO {

    @NotNull(message = "专辑ID不能为空")
    private Long albumId;

    @NotNull(message = "购买数量不能为空")
    @Min(value = 1, message = "购买数量至少为1")
    private Integer quantity;
}