package com.music.musicsystem.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.music.musicsystem.entity.OrderItem;
import org.apache.ibatis.annotations.Mapper;

/**
 * 提供订单明细的持久化访问接口。
 */
@Mapper
public interface OrderItemMapper extends BaseMapper<OrderItem> {
}
