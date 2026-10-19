package com.music.musicsystem.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.IService;
import com.music.musicsystem.dto.UserLoginDTO;
import com.music.musicsystem.dto.UserRegisterDTO;
import com.music.musicsystem.entity.SysUser;
import com.music.musicsystem.vo.LoginVO;
import com.music.musicsystem.vo.UserVO;

/**
 * 定义用户登录、注册及后台用户管理操作。
 */

public interface SysUserService extends IService<SysUser> {

    /**
     * 用户注册
     */
    UserVO register(UserRegisterDTO dto);

    /**
     * 根据用户名查询用
     */
    SysUser getByUsername(String username);
    /**
     * 用户登录
     */
    LoginVO login(UserLoginDTO dto);

    /**
     * 分页查询后台用户列表。
     */
    Page<UserVO> getAdminUserList(Integer current, Integer size, String keyword);

    /**
     * 修改用户账号状态。
     */
    void changeUserStatus(Long operatorId, String operatorRole, Long userId, Integer status);

    /**
     * 修改用户角色。
     */
    void changeUserRole(Long operatorId, String operatorRole, Long userId, String role);
}