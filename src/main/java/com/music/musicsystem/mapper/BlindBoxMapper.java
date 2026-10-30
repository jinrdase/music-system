package com.music.musicsystem.mapper;


import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.music.musicsystem.entity.BlindBox;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

/**
 * 提供对应业务数据的 MyBatis 持久化访问接口。
 * 盲盒Mapper
 */
@Mapper
public interface BlindBoxMapper extends BaseMapper<BlindBox> {

    /**
     * 扣减库存（乐观锁
     */
    @Update("UPDATE blind_box SET remain_count = remain_count - #{count} " +
            "WHERE id = #{boxId} AND remain_count >= #{count}")
    /**
     * 原子扣减盲盒奖品库存，并返回受影响行数。
     */
    int deductStock(@Param("boxId") Long boxId, @Param("count") Integer count);

    /**
     * 原子回补盲盒库存（订单取消/超时/退款/抽取失败自动退款时使用），返回受影响行数。
     */
    @Update("UPDATE blind_box SET remain_count = remain_count + #{count} WHERE id = #{boxId}")
    int restoreStock(@Param("boxId") Long boxId, @Param("count") Integer count);
}