package com.music.musicsystem.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 修改个人资料入参（username 不允许修改，不在入参中）。
 */
@Data
public class ProfileUpdateDTO {

    @Size(min = 2, max = 20, message = "昵称长度为2-20个字符")
    private String nickname;

    /** 11 位有效手机号，全库唯一 */
    private String phone;

    /** 邮箱格式合法，全库唯一 */
    private String email;

    /** 头像地址（由 /api/user/avatar 上传接口返回的 /media 路径） */
    @Size(max = 255, message = "头像地址过长")
    private String avatar;
}
