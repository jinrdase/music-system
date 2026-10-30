package com.music.musicsystem.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 后台订单列表视图对象：在 OrderVO 基础上补充下单用户名。
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class AdminOrderVO extends OrderVO {

    /** 下单用户名（联查 sys_user） */
    private String username;
}
