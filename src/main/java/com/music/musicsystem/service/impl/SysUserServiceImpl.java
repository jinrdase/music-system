package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.impl.ServiceImpl;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.dto.PasswordChangeDTO;
import com.music.musicsystem.dto.ProfileUpdateDTO;
import com.music.musicsystem.dto.UserLoginDTO;
import com.music.musicsystem.dto.UserRegisterDTO;
import com.music.musicsystem.entity.SysUser;
import com.music.musicsystem.mapper.SysUserMapper;
import com.music.musicsystem.service.SysUserService;
import com.music.musicsystem.util.JwtUtil;
import com.music.musicsystem.vo.LoginVO;
import com.music.musicsystem.vo.UserVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * 实现用户认证、注册和后台用户管理业务。
 */

@Service
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser> implements SysUserService {

    @Autowired
    private JwtUtil jwtUtil;
    /**
     * 分页查询后台用户列表。
     */

    @Override
    public Page<UserVO> getAdminUserList(Integer current, Integer size, String keyword) {
        LambdaQueryWrapper<SysUser> query = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isBlank()) {
            query.and(wrapper -> wrapper.like(SysUser::getUsername, keyword)
                    .or().like(SysUser::getNickname, keyword)
                    .or().like(SysUser::getPhone, keyword));
        }
        query.orderByDesc(SysUser::getCreateTime);
        Page<SysUser> page = this.page(new Page<>(current, size), query);
        Page<UserVO> result = new Page<>(current, size, page.getTotal());
        List<UserVO> users = page.getRecords().stream().map(user -> {
            UserVO vo = new UserVO();
            BeanUtils.copyProperties(user, vo);
            return vo;
        }).toList();
        result.setRecords(users);
        return result;
    }
    /**
     * 修改用户账号状态。
     */

    @Override
    public void changeUserStatus(Long operatorId, String operatorRole, Long userId, Integer status) {
        if (operatorId.equals(userId)) {
            throw new BusinessException("不能修改自己的账号状态");
        }
        SysUser target = this.getById(userId);
        if (target == null) {
            throw new BusinessException("用户不存在");
        }
        if (!"super_admin".equalsIgnoreCase(operatorRole)
                && !"user".equalsIgnoreCase(target.getRole())) {
            throw new BusinessException("管理员只能管理普通用户账号");
        }
        if (target.getStatus() != null && target.getStatus().equals(status)) {
            return;
        }
        boolean updated = this.update(
                new LambdaUpdateWrapper<SysUser>()
                        .eq(SysUser::getId, userId)
                        .set(SysUser::getStatus, status)
        );
        if (!updated) {
            throw new BusinessException("用户状态更新失败");
        }
    }
    /**
     * 修改用户角色。
     */

    @Override
    public void changeUserRole(Long operatorId, String operatorRole, Long userId, String role) {
        if (!"super_admin".equalsIgnoreCase(operatorRole)) {
            throw new BusinessException(403, "只有超级管理员可以调整用户角色");
        }
        if (operatorId.equals(userId)) {
            throw new BusinessException("不能修改自己的角色");
        }
        if (!List.of("user", "admin", "super_admin").contains(role)) {
            throw new BusinessException("无效的用户角色");
        }
        SysUser target = this.getById(userId);
        if (target == null) {
            throw new BusinessException("用户不存在");
        }
        target.setRole(role);
        if (!this.updateById(target)) {
            throw new BusinessException("用户角色更新失败");
        }
    }
    /**
     * 校验用户凭据并创建登录结果。
     */
    @Override
    public LoginVO login(UserLoginDTO dto) {
        // 1. 查询用户
        SysUser user = getByUsername(dto.getUsername());
        if (user == null) {
            throw new BusinessException("用户名或密码错误");
        }

        // 2. 校验密码
        String encryptedPassword = encryptPassword(dto.getPassword());
        if (!encryptedPassword.equals(user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }

        // 3. 检查用户状
        if (user.getStatus() == 0) {
            throw new BusinessException("账号已被禁用，请联系管理员");
        }

        // 4. 生成 Token
        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole());

        // 5. 返回登录信息
        UserVO userVO = new UserVO();
        BeanUtils.copyProperties(user, userVO);

        return new LoginVO(token, userVO);
    }

    /**
     * 修改个人资料：格式校验 + 手机号/邮箱全库唯一（不含本人），username 不可修改。
     */
    @Override
    public UserVO updateProfile(Long userId, ProfileUpdateDTO dto) {
        SysUser user = this.getById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        if (dto.getNickname() != null) {
            String nickname = dto.getNickname().trim();
            if (nickname.length() < 2 || nickname.length() > 20) {
                throw new BusinessException("昵称长度为2-20个字符");
            }
            user.setNickname(nickname);
        }
        if (dto.getPhone() != null) {
            String phone = dto.getPhone().trim();
            if (!phone.matches("^1[3-9]\\d{9}$")) {
                throw new BusinessException("手机号格式不正确");
            }
            Long used = this.count(new LambdaQueryWrapper<SysUser>()
                    .eq(SysUser::getPhone, phone)
                    .ne(SysUser::getId, userId));
            if (used > 0) {
                throw new BusinessException("手机号已被其他账号使用");
            }
            user.setPhone(phone);
        }
        if (dto.getEmail() != null) {
            String email = dto.getEmail().trim();
            if (!email.matches("^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
                throw new BusinessException("邮箱格式不正确");
            }
            Long used = this.count(new LambdaQueryWrapper<SysUser>()
                    .eq(SysUser::getEmail, email)
                    .ne(SysUser::getId, userId));
            if (used > 0) {
                throw new BusinessException("邮箱已被其他账号使用");
            }
            user.setEmail(email);
        }
        if (dto.getAvatar() != null) {
            user.setAvatar(dto.getAvatar().trim());
        }

        this.updateById(user);
        UserVO vo = new UserVO();
        BeanUtils.copyProperties(user, vo);
        return vo;
    }

    /**
     * 修改密码：旧密码校验、强度（8-20 位且同时包含字母与数字）、两次一致、不得与旧密码相同。
     * 修改成功后旧 JWT 在有效期内仍可用（服务端无黑名单，课程范围内的可接受简化）。
     */
    @Override
    public void changePassword(Long userId, PasswordChangeDTO dto) {
        SysUser user = this.getById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        if (!encryptPassword(dto.getOldPassword()).equals(user.getPassword())) {
            throw new BusinessException("旧密码不正确");
        }
        if (!dto.getNewPassword().equals(dto.getConfirmPassword())) {
            throw new BusinessException("两次输入的新密码不一致");
        }
        if (!dto.getNewPassword().matches("^(?=.*[A-Za-z])(?=.*\\d).{8,20}$")) {
            throw new BusinessException("新密码需为8-20位且同时包含字母与数字");
        }
        if (dto.getNewPassword().equals(dto.getOldPassword())) {
            throw new BusinessException("新密码不能与旧密码相同");
        }
        user.setPassword(encryptPassword(dto.getNewPassword()));
        this.updateById(user);
    }
    /**
     * 校验注册信息并创建新用户。
     */

    @Override
    public UserVO register(UserRegisterDTO dto) {
        // 1. 校验两次密码是否一
        if (!dto.getPassword().equals(dto.getConfirmPassword())) {
            throw new BusinessException("两次密码输入不一致");
        }

        // 2. 检查用户名是否已存
        SysUser existUser = getByUsername(dto.getUsername());
        if (existUser != null) {
            throw new BusinessException("用户名已存在");
        }

        // 3. 检查手机号是否已存
        if (dto.getPhone() != null && !dto.getPhone().isEmpty()) {
            LambdaQueryWrapper<SysUser> phoneQuery = new LambdaQueryWrapper<>();
            phoneQuery.eq(SysUser::getPhone, dto.getPhone());
            if (this.count(phoneQuery) > 0) {
                throw new BusinessException("手机号已被注册");
            }
        }

        // 4. 检查邮箱是否已存在
        if (dto.getEmail() != null && !dto.getEmail().isEmpty()) {
            LambdaQueryWrapper<SysUser> emailQuery = new LambdaQueryWrapper<>();
            emailQuery.eq(SysUser::getEmail, dto.getEmail());
            if (this.count(emailQuery) > 0) {
                throw new BusinessException("邮箱已被注册");
            }
        }

        // 5. 创建用户
        SysUser user = new SysUser();
        user.setUsername(dto.getUsername());
        user.setPassword(encryptPassword(dto.getPassword()));
        user.setNickname(dto.getNickname() != null ? dto.getNickname() : dto.getUsername());
        user.setPhone(dto.getPhone());
        user.setEmail(dto.getEmail());
        user.setStatus(1);
        user.setRole("user");

        this.save(user);

        // 6. 返回用户信息
        UserVO vo = new UserVO();
        BeanUtils.copyProperties(user, vo);
        return vo;
    }
    /**
     * 根据用户名查询用户信息。
     */

    @Override
    public SysUser getByUsername(String username) {
        LambdaQueryWrapper<SysUser> query = new LambdaQueryWrapper<>();
        query.eq(SysUser::getUsername, username);
        return this.getOne(query);
    }

    /**
     * 密码加密（MD5
     */
    private String encryptPassword(String password) {
        String salt = "music_system_salt_2026";
        String rawPassword = password + salt;
        return DigestUtils.md5DigestAsHex(rawPassword.getBytes(StandardCharsets.UTF_8));
    }
}