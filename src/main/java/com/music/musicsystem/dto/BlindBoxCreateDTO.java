package com.music.musicsystem.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class BlindBoxCreateDTO {
    @NotBlank(message = "盲盒名称不能为空")
    @Size(max = 200, message = "盲盒名称不能超过200个字符")
    private String name;

    @Size(max = 1000, message = "盲盒封面地址不能超过1000个字符")
    private String coverUrl;

    @NotNull(message = "关联专辑不能为空")
    private Long albumId;

    @Size(max = 1000, message = "盲盒描述不能超过1000个字符")
    private String description;

    @NotNull(message = "单抽价格不能为空")
    @DecimalMin(value = "0.00", inclusive = false, message = "单抽价格必须大于0")
    private BigDecimal price;

    @NotNull(message = "盲盒库存不能为空")
    @Min(value = 1, message = "盲盒库存必须大于0")
    private Integer totalCount;

    @NotEmpty(message = "至少配置一个奖品")
    @Size(max = 100, message = "奖品配置不能超过100项")
    private List<@Valid Prize> prizes;

    /**
     * 描述盲盒中的单个奖品及其概率、图片和说明。
     */

    @Data
    public static class Prize {
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
}
