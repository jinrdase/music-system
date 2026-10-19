package com.music.musicsystem.controller;

import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.UserLoginDTO;
import com.music.musicsystem.dto.UserRegisterDTO;
import com.music.musicsystem.entity.SysUser;
import com.music.musicsystem.service.SysUserService;
import com.music.musicsystem.vo.LoginVO;
import com.music.musicsystem.vo.UserVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 处理用户注册、登录和个人信息请求。
 */

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private SysUserService sysUserService;

    /**
     * 用户注册
     */
    @PostMapping("/register")
    public Result<UserVO> register(@Validated @RequestBody UserRegisterDTO dto) {
        UserVO userVO = sysUserService.register(dto);
        return Result.success("注册成功", userVO);
    }
    /**
     * 用户登录
     */
    @PostMapping("/login")
    public Result<LoginVO> login(@Validated @RequestBody UserLoginDTO dto) {
        LoginVO loginVO = sysUserService.login(dto);
        return Result.success("登录成功", loginVO);
    }
    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/info")
    public Result<UserVO> getUserInfo(HttpServletRequest request) {
        // 从拦截器中获取用户ID
        Long userId = (Long) request.getAttribute("userId");

        SysUser user = sysUserService.getById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        UserVO userVO = new UserVO();
        BeanUtils.copyProperties(user, userVO);

        return Result.success(userVO);
    }
}