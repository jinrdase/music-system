package com.music.musicsystem.controller;

import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.AddressDTO;
import com.music.musicsystem.service.UserAddressService;
import com.music.musicsystem.util.JwtUtil;
import com.music.musicsystem.vo.AddressVO;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 处理用户收货地址的新增、修改、删除和查询请求。
 */

@RestController
@RequestMapping("/api/address")
public class AddressController {

    @Resource
    private UserAddressService userAddressService;

    @Resource
    private JwtUtil jwtUtil;

    /**
     * 新增收货地址。
     */
    @PostMapping("/add")
    public Result<Long> addAddress(@Validated @RequestBody AddressDTO dto,
                                   HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        Long addressId = userAddressService.addAddress(userId, dto);
        return Result.success(addressId);
    }

    /**
     * 修改收货地址。
     */
    @PutMapping("/update/{addressId}")
    public Result<Void> updateAddress(@PathVariable Long addressId,
                                      @Validated @RequestBody AddressDTO dto,
                                      HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        userAddressService.updateAddress(userId, addressId, dto);
        return Result.success();
    }

    /**
     * 删除收货地址
     */
    @DeleteMapping("/delete/{addressId}")
    public Result<Void> deleteAddress(@PathVariable Long addressId,
                                      HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        userAddressService.deleteAddress(userId, addressId);
        return Result.success();
    }

    /**
     * 设置默认地址
     */
    @PutMapping("/setDefault/{addressId}")
    public Result<Void> setDefaultAddress(@PathVariable Long addressId,
                                          HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        userAddressService.setDefaultAddress(userId, addressId);
        return Result.success();
    }

    /**
     * 查询用户所有地址
     */
    @GetMapping("/list")
    public Result<List<AddressVO>> listAddresses(HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        List<AddressVO> addresses = userAddressService.listUserAddresses(userId);
        return Result.success(addresses);
    }

    /**
     * 查询地址详情
     */
    @GetMapping("/detail/{addressId}")
    public Result<AddressVO> getAddressDetail(@PathVariable Long addressId,
                                              HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        AddressVO address = userAddressService.getAddressDetail(userId, addressId);
        return Result.success(address);
    }

    /**
     * 获取默认地址
     */
    @GetMapping("/default")
    public Result<AddressVO> getDefaultAddress(HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        AddressVO address = userAddressService.getDefaultAddress(userId);
        return Result.success(address);
    }

    /**
     * 从Token获取当前用户ID
     */
    private Long getCurrentUserId(HttpServletRequest request) {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        return jwtUtil.getUserIdFromToken(token);
    }
}