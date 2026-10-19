package com.music.musicsystem.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.dto.SongManagementDTO;
import com.baomidou.mybatisplus.spring.service.IService;
import com.music.musicsystem.entity.Song;
import com.music.musicsystem.vo.SongVO;

/**
 * 定义歌曲查询与后台管理操作。
 */

public interface SongService extends IService<Song> {

    /**
     * 增加播放次数
     */
    void increasePlayCount(Long songId);

    /**
     * 分页查询后台歌曲列表。
     */
    Page<SongVO> getAdminSongs(Long albumId, Integer current, Integer size);

    /**
     * 创建歌曲并返回新记录的编号。
     */
    Long createSong(SongManagementDTO dto);

    /**
     * 更新指定歌曲的信息。
     */
    void updateSong(Long songId, SongManagementDTO dto);
}