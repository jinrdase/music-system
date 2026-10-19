package com.music.musicsystem.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class RefundReviewDTO {
    @NotNull(message = "审核结果不能为空")
    private Boolean approved;

    @Size(max = 500, message = "审核备注最多500个字符")
    private String auditRemark;
}