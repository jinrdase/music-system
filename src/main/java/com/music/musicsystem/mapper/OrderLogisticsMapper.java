package com.music.musicsystem.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.music.musicsystem.entity.OrderLogistics;
import org.apache.ibatis.annotations.Mapper;

/**
 * 提供对应业务数据的 MyBatis 持久化访问接口。
 */

@Mapper
public interface OrderLogisticsMapper extends BaseMapper<OrderLogistics> {
}