
package com.music.musicsystem.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.List;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class RefundDTO {

    @NotNull(message = "订单ID不能为空")
    private Long orderId;

    @NotBlank(message = "退款原因不能为空")
    @Size(max = 100, message = "退款原因最多100个字符")
    private String reason;

    @Size(max = 500, message = "详细说明最多500个字符")
    private String description;

    @Size(max = 9, message = "凭证图片最多9张")
    private List<String> images; // 凭证图片URL列表

    @Size(max = 100, message = "退货物流公司名称不能超过100个字符")
    private String returnCarrier;

    @Size(max = 100, message = "退货物流单号不能超过100个字符")
    private String returnTrackingNo;
}