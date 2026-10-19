package com.music.musicsystem.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class AlbumManagementDTO {

    @NotBlank(message = "专辑名称不能为空")
    @Size(max = 255, message = "专辑名称不能超过255个字符")
    private String title;

    @NotBlank(message = "艺人名称不能为空")
    @Size(max = 255, message = "艺人名称不能超过255个字符")
    private String artist;

    @Size(max = 1000, message = "封面地址不能超过1000个字符")
    private String coverUrl;

    @Size(max = 2000, message = "专辑介绍不能超过2000个字符")
    private String description;

    private String productType = "PHYSICAL";

    @Size(max = 2000, message = "数字内容地址不能超过2000个字符")
    private String digitalContentUrl;

    private LocalDate releaseDate;

    @NotNull(message = "专辑价格不能为空")
    @DecimalMin(value = "0.00", inclusive = false, message = "专辑价格必须大于0")
    private BigDecimal price;

    @NotNull(message = "库存不能为空")
    @Min(value = 0, message = "库存不能小于0")
    private Integer stock;

    @NotNull(message = "商品状态不能为空")
    private Integer status;

    @NotNull(message = "限量标记不能为空")
    private Integer isLimited;
}