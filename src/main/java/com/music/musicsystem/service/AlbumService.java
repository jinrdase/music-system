package com.music.musicsystem.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.IService;
import com.music.musicsystem.entity.Album;
import com.music.musicsystem.dto.AlbumManagementDTO;
import com.music.musicsystem.vo.AlbumDetailVO;
import com.music.musicsystem.vo.AlbumVO;

/**
 * 定义专辑查询与后台管理业务操作。
 */

public interface AlbumService extends IService<Album> {

    /**
     * 分页查询专辑列表
     */
    Page<AlbumVO> getAlbumList(Integer current, Integer size, String keyword);

    /**
     * 获取专辑详情（包含歌曲列表）
     */
    AlbumDetailVO getAlbumDetail(Long id);

    /**
     * 分页查询后台专辑列表。
     */
    Page<AlbumVO> getAdminAlbumList(Integer current, Integer size, String keyword);

    /**
     * 创建专辑并返回新记录的编号。
     */
    Long createAlbum(AlbumManagementDTO dto);

    /**
     * 更新指定专辑信息。
     */
    void updateAlbum(Long albumId, AlbumManagementDTO dto);

    /**
     * 修改指定专辑的上架状态。
     */
    void changeAlbumStatus(Long albumId, Integer status);
}