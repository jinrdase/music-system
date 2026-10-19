package com.music.musicsystem.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class ShipOrderDTO {

    @NotBlank(message = "物流公司不能为空")
    @Size(max = 100, message = "物流公司名称不能超过100个字符")
    private String carrier;

    @NotBlank(message = "物流单号不能为空")
    @Size(max = 100, message = "物流单号不能超过100个字符")
    private String trackingNo;
}