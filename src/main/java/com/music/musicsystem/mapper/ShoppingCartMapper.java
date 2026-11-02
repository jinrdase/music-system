package com.music.musicsystem.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.music.musicsystem.entity.ShoppingCart;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 提供对应业务数据的 MyBatis 持久化访问接口。
 */

@Mapper
public interface ShoppingCartMapper extends BaseMapper<ShoppingCart> {

    /**
     * 物理删除购物车项（绕过 @TableLogic 的逻辑删除）。
     * 购物车数据无审计价值；物理删除配合 (user_id, album_id) 唯一键
     * 才能防并发加购重复并允许“删除后重新加购”（审查 L-7）。
     */
    @Delete("DELETE FROM shopping_cart WHERE id = #{id}")
    int physicalDeleteById(@Param("id") Long id);

    /**
     * 物理清空指定用户购物车。
     */
    @Delete("DELETE FROM shopping_cart WHERE user_id = #{userId}")
    int physicalDeleteByUserId(@Param("userId") Long userId);
}
