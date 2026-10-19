
package com.music.musicsystem.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class UserLoginDTO {

    @NotBlank(message = "用户名不能为空")
    private String username;

    @NotBlank(message = "密码不能为空")
    private String password;
}