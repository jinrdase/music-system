package com.music.musicsystem.service;

import com.music.musicsystem.dto.AddressDTO;
import com.music.musicsystem.vo.AddressVO;
import java.util.List;

/**
 * 定义用户收货地址维护和查询操作。
 */

public interface UserAddressService {

    /**
     * 新增收货地址。
     */
    Long addAddress(Long userId, AddressDTO dto);

    /**
     * 修改收货地址。
     */
    void updateAddress(Long userId, Long addressId, AddressDTO dto);

    /**
     * 删除收货地址
     */
    void deleteAddress(Long userId, Long addressId);

    /**
     * 设置默认地址
     */
    void setDefaultAddress(Long userId, Long addressId);

    /**
     * 查询用户所有地址
     */
    List<AddressVO> listUserAddresses(Long userId);

    /**
     * 查询地址详情
     */
    AddressVO getAddressDetail(Long userId, Long addressId);

    /**
     * 获取默认地址
     */
    AddressVO getDefaultAddress(Long userId);
}