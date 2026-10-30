package com.music.musicsystem.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 购物车合并结算入参：对购物车已勾选商品一次性下单。
 */
@Data
public class CreateFromCartDTO {

    /** 结算含实物明细时必填；全数字明细不传。 */
    private Long addressId;

    @Size(max = 500, message = "备注最多500个字符")
    private String remark;
}
