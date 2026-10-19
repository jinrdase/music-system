package com.music.musicsystem.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class BlindBoxPrizeDTO {
    @NotBlank(message = "奖品名称不能为空")
    @Size(max = 200, message = "奖品名称不能超过200个字符")
    private String prizeName;

    @NotNull(message = "奖品稀有度不能为空")
    private Integer prizeLevel;

    @NotNull(message = "奖品概率不能为空")
    @DecimalMin(value = "0", inclusive = false, message = "奖品概率必须大于0")
    private BigDecimal probability;

    @Size(max = 1000, message = "奖品图片地址不能超过1000个字符")
    private String imageUrl;

    @Size(max = 1000, message = "奖品描述不能超过1000个字符")
    private String description;
}