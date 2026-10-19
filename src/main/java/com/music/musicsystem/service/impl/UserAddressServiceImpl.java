package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.dto.AddressDTO;
import com.music.musicsystem.entity.UserAddress;
import com.music.musicsystem.mapper.UserAddressMapper;
import com.music.musicsystem.service.UserAddressService;
import com.music.musicsystem.vo.AddressVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 实现用户收货地址维护和查询业务。
 */

@Service
public class UserAddressServiceImpl implements UserAddressService {

    @Resource
    private UserAddressMapper userAddressMapper;

    private static final Integer MAX_ADDRESS_COUNT = 20;
    /**
     * 为用户新增收货地址。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long addAddress(Long userId, AddressDTO dto) {
        // 1. 检查地址数量限制
        Long count = userAddressMapper.selectCount(
                new LambdaQueryWrapper<UserAddress>().eq(UserAddress::getUserId, userId)
        );
        if (count >= MAX_ADDRESS_COUNT) {
            throw new BusinessException("收货地址最多10条，请删除后再添加");
        }

        // 2. 创建地址实体。
        UserAddress address = new UserAddress();
        BeanUtils.copyProperties(dto, address);
        address.setUserId(userId);

        // 3. 如果设置为默认地址，先取消其他默认地址
        if (dto.getIsDefault() != null && dto.getIsDefault() == 1) {
            cancelOtherDefaultAddress(userId);
        } else {
            // 如果是第一条地址，自动设为默
            if (count == 0) {
                address.setIsDefault(1);
            } else {
                address.setIsDefault(0);
            }
        }

        // 4. 保存地址。
        userAddressMapper.insert(address);
        return address.getId();
    }
    /**
     * 更新用户的指定收货地址。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateAddress(Long userId, Long addressId, AddressDTO dto) {
        // 1. 校验地址归属。
        UserAddress address = getAndCheckAddress(userId, addressId);

        // 2. 更新地址信息
        BeanUtils.copyProperties(dto, address);

        // 3. 如果设置为默认地址，先取消其他默认地址
        if (dto.getIsDefault() != null && dto.getIsDefault() == 1) {
            cancelOtherDefaultAddress(userId);
            address.setIsDefault(1);
        }

        userAddressMapper.updateById(address);
    }
    /**
     * 删除用户的指定收货地址。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteAddress(Long userId, Long addressId) {
        // 1. 校验地址归属。
        UserAddress address = getAndCheckAddress(userId, addressId);

        // 2. 删除地址
        userAddressMapper.deleteById(addressId);

        // 3. 如果删除的是默认地址，自动设置第一条为默认
        if (address.getIsDefault() == 1) {
            UserAddress firstAddress = userAddressMapper.selectOne(
                    new LambdaQueryWrapper<UserAddress>()
                            .eq(UserAddress::getUserId, userId)
                            .last("LIMIT 1")
            );
            if (firstAddress != null) {
                firstAddress.setIsDefault(1);
                userAddressMapper.updateById(firstAddress);
            }
        }
    }
    /**
     * 将用户指定地址设为默认地址。
     */

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setDefaultAddress(Long userId, Long addressId) {
        // 1. 校验地址归属。
        getAndCheckAddress(userId, addressId);

        // 2. 取消其他默认地址
        cancelOtherDefaultAddress(userId);

        // 3. 设置为默
        userAddressMapper.update(null,
                new LambdaUpdateWrapper<UserAddress>()
                        .set(UserAddress::getIsDefault, 1)
                        .eq(UserAddress::getId, addressId)
        );
    }
    /**
     * 查询用户的全部收货地址。
     */

    @Override
    public List<AddressVO> listUserAddresses(Long userId) {
        List<UserAddress> addresses = userAddressMapper.selectList(
                new LambdaQueryWrapper<UserAddress>()
                        .eq(UserAddress::getUserId, userId)
                        .orderByDesc(UserAddress::getIsDefault)
                        .orderByDesc(UserAddress::getCreateTime)
        );

        return addresses.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
    }
    /**
     * 查询用户指定收货地址的详情。
     */

    @Override
    public AddressVO getAddressDetail(Long userId, Long addressId) {
        UserAddress address = getAndCheckAddress(userId, addressId);
        return convertToVO(address);
    }
    /**
     * 查询用户当前的默认收货地址。
     */

    @Override
    public AddressVO getDefaultAddress(Long userId) {
        UserAddress address = userAddressMapper.selectOne(
                new LambdaQueryWrapper<UserAddress>()
                        .eq(UserAddress::getUserId, userId)
                        .eq(UserAddress::getIsDefault, 1)
        );

        if (address == null) {
            throw new BusinessException("请先添加收货地址");
        }

        return convertToVO(address);
    }

    /**
     * 取消用户其他默认地址
     */
    private void cancelOtherDefaultAddress(Long userId) {
        userAddressMapper.update(null,
                new LambdaUpdateWrapper<UserAddress>()
                        .set(UserAddress::getIsDefault, 0)
                        .eq(UserAddress::getUserId, userId)
                        .eq(UserAddress::getIsDefault, 1)
        );
    }

    /**
     * 获取地址并校验归
     */
    private UserAddress getAndCheckAddress(Long userId, Long addressId) {
        UserAddress address = userAddressMapper.selectById(addressId);
        if (address == null) {
            throw new BusinessException("地址不存在");
        }
        if (!address.getUserId().equals(userId)) {
            throw new BusinessException("无权操作该地址");
        }
        return address;
    }

    /**
     * 瀹炰綋杞琕O
     */
    private AddressVO convertToVO(UserAddress address) {
        AddressVO vo = new AddressVO();
        BeanUtils.copyProperties(address, vo);
        vo.setFullAddress(address.getProvince() + address.getCity() +
                address.getDistrict() + address.getDetailAddress());
        return vo;
    }
}