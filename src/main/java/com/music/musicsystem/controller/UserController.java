package com.music.musicsystem.controller;

import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.PasswordChangeDTO;
import com.music.musicsystem.dto.ProfileUpdateDTO;
import com.music.musicsystem.dto.UserLoginDTO;
import com.music.musicsystem.dto.UserRegisterDTO;
import com.music.musicsystem.entity.SysUser;
import com.music.musicsystem.service.SysUserService;
import com.music.musicsystem.vo.LoginVO;
import com.music.musicsystem.vo.UserVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.StringUtils;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

/**
 * 处理用户注册、登录和个人信息请求。
 */

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private SysUserService sysUserService;

    /** 头像存储目录（复用媒体上传目录与 /media 静态映射） */
    @Value("${music.upload.directory:${user.home}/music-system-uploads}")
    private String uploadDirectory;

    private static final long MAX_AVATAR_SIZE = 2L * 1024 * 1024;

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

    /**
     * 修改个人资料（昵称/手机/邮箱/头像地址）。
     */
    @PutMapping("/profile")
    public Result<UserVO> updateProfile(@Validated @RequestBody ProfileUpdateDTO dto,
                                        HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success("资料更新成功", sysUserService.updateProfile(userId, dto));
    }

    /**
     * 修改密码：成功后前端清除本地令牌并引导重新登录。
     */
    @PutMapping("/password")
    public Result<Void> changePassword(@Validated @RequestBody PasswordChangeDTO dto,
                                       HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        sysUserService.changePassword(userId, dto);
        return Result.success("密码修改成功，请重新登录", null);
    }

    /**
     * 头像上传：仅 JPG/PNG（按文件头魔数校验），不超过 2MB，存储复用媒体上传目录。
     * 返回 /media 路径，作为 PUT /api/user/profile 的 avatar 入参。
     */
    @PostMapping("/avatar")
    public Result<Map<String, String>> uploadAvatar(@RequestParam("file") MultipartFile file,
                                                    HttpServletRequest request) {
        // 需登录（拦截器已保证），userId 用于审计留痕
        Long userId = (Long) request.getAttribute("userId");
        if (file == null || file.isEmpty()) {
            throw new BusinessException("请选择要上传的文件");
        }
        if (file.getSize() > MAX_AVATAR_SIZE) {
            throw new BusinessException("头像不能超过2MB");
        }
        String originalName = StringUtils.cleanPath(file.getOriginalFilename() == null ? "" : file.getOriginalFilename());
        String extension = StringUtils.getFilenameExtension(originalName);
        if (extension == null) {
            throw new BusinessException("文件扩展名无效");
        }
        extension = extension.toLowerCase(Locale.ROOT);
        if (!"jpg".equals(extension) && !"jpeg".equals(extension) && !"png".equals(extension)) {
            throw new BusinessException("头像仅支持 JPG/PNG");
        }
        try (InputStream input = file.getInputStream()) {
            byte[] head = input.readNBytes(12);
            boolean signatureOk = switch (extension) {
                case "png" -> head.length >= 8 && (head[0] & 0xff) == 0x89 && (head[1] & 0xff) == 0x50
                        && (head[2] & 0xff) == 0x4e && (head[3] & 0xff) == 0x47;
                default -> head.length >= 3 && (head[0] & 0xff) == 0xff
                        && (head[1] & 0xff) == 0xd8 && (head[2] & 0xff) == 0xff;
            };
            if (!signatureOk) {
                throw new BusinessException("文件内容与图片格式不匹配");
            }
        } catch (IOException e) {
            throw new BusinessException("无法读取上传文件");
        }
        Path root = Path.of(uploadDirectory).toAbsolutePath().normalize();
        String fileName = "avatar-" + userId + "-" + UUID.randomUUID().toString().replace("-", "") + "." + extension;
        Path target = root.resolve("image").resolve(fileName).normalize();
        if (!target.startsWith(root)) {
            throw new BusinessException("文件路径无效");
        }
        try {
            Files.createDirectories(target.getParent());
            file.transferTo(target);
        } catch (IOException e) {
            throw new BusinessException("头像保存失败");
        }
        return Result.success(Map.of("url", "/media/image/" + fileName));
    }
}