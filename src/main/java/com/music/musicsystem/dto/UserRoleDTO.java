package com.music.musicsystem.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class UserRoleDTO {
    @NotBlank
    @Pattern(regexp = "user|admin|super_admin", message = "角色只能是user、admin或super_admin")
    private String role;
}