
package com.music.musicsystem.dto;

import lombok.Data;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */
@Data
public class DrawRequestDTO {

    /** 盲盒ID */
    @NotNull(message = "盲盒ID不能为空")
    private Long boxId;

    /** 抽奖次数：1为单抽，10为十连抽 */
    @NotNull(message = "抽奖次数不能为空")
    @Min(value = 1, message = "抽奖次数至少为1")
    @Max(value = 10, message = "抽奖次数最多为10")
    private Integer drawCount;
}