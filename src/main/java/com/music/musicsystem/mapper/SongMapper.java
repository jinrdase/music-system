package com.music.musicsystem.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.music.musicsystem.entity.Song;
import org.apache.ibatis.annotations.Mapper;

/**
 * 提供对应业务数据的 MyBatis 持久化访问接口。
 */

@Mapper
public interface SongMapper extends BaseMapper<Song> {
}