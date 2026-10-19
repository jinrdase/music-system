package com.music.musicsystem.vo;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class UserVO {

    private Long id;
    private String username;
    private String nickname;
    private String phone;
    private String email;
    private String avatar;
    private Integer status;
    private String role;
    private LocalDateTime createTime;
}