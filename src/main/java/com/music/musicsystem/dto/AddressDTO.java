
package com.music.musicsystem.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class AddressDTO {

    @NotBlank(message = "收件人姓名不能为空")
    @Size(min = 2, max = 20, message = "收件人姓名长度必须在2-20个字符之间")
    private String receiverName;

    @NotBlank(message = "收件人手机号不能为空")
    @Pattern(
            regexp = "^1[3-9]\\d{9}$",
            message = "请输入正确的手机号码"
    )
    private String receiverPhone;

    @NotBlank(message = "省份不能为空")
    private String province;

    @NotBlank(message = "城市不能为空")
    private String city;

    @NotBlank(message = "区县不能为空")
    private String district;

    @NotBlank(message = "详细地址不能为空")
    @Size(min = 5, max = 100, message = "详细地址长度必须在5-100个字符之间")
    private String detailAddress;

    /**
     * 是否默认地址：0-否，1-是
     */
    private Integer isDefault;
}