package com.music.musicsystem.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class UserStatusDTO {
    @NotNull(message = "用户状态不能为空")
    private Integer status;
}