package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.impl.ServiceImpl;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.entity.Album;
import com.music.musicsystem.dto.AlbumManagementDTO;
import com.music.musicsystem.entity.Song;
import com.music.musicsystem.mapper.AlbumMapper;
import com.music.musicsystem.mapper.SongMapper;
import com.music.musicsystem.service.AlbumService;
import com.music.musicsystem.vo.AlbumDetailVO;
import com.music.musicsystem.vo.AlbumVO;
import com.music.musicsystem.vo.SongVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 实现专辑查询、管理和详情组装业务。
 */

@Service
public class AlbumServiceImpl extends ServiceImpl<AlbumMapper, Album> implements AlbumService {

    @Autowired
    private SongMapper songMapper;
    /**
     * 分页查询后台专辑列表，可按关键词筛选。
     */

    @Override
    public Page<AlbumVO> getAdminAlbumList(Integer current, Integer size, String keyword) {
        LambdaQueryWrapper<Album> query = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isBlank()) {
            query.and(wrapper -> wrapper.like(Album::getTitle, keyword)
                    .or().like(Album::getArtist, keyword));
        }
        query.orderByDesc(Album::getCreateTime);
        Page<Album> page = this.page(new Page<>(current, size), query);
        Page<AlbumVO> result = new Page<>(current, size, page.getTotal());
        result.setRecords(page.getRecords().stream().map(album -> {
            AlbumVO vo = new AlbumVO();
            BeanUtils.copyProperties(album, vo);
            return vo;
        }).toList());
        return result;
    }
    /**
     * 根据管理请求创建专辑。
     */

    @Override
    public Long createAlbum(AlbumManagementDTO dto) {
        Album album = new Album();
        BeanUtils.copyProperties(dto, album);
        album.setTitle(dto.getTitle().trim());
        album.setArtist(dto.getArtist().trim());
        album.setStock(dto.getStock());
        album.setSales(0);
        this.save(album);
        return album.getId();
    }
    /**
     * 更新指定专辑的信息。
     */

    @Override
    public void updateAlbum(Long albumId, AlbumManagementDTO dto) {
        Album album = this.getById(albumId);
        if (album == null) {
            throw new BusinessException("专辑不存在");
        }
        BeanUtils.copyProperties(dto, album);
        album.setTitle(dto.getTitle().trim());
        album.setArtist(dto.getArtist().trim());
        if (!this.updateById(album)) {
            throw new BusinessException("专辑信息更新失败");
        }
    }
    /**
     * 修改指定专辑的上架状态。
     */

    @Override
    public void changeAlbumStatus(Long albumId, Integer status) {
        Album album = this.getById(albumId);
        if (album == null) {
            throw new BusinessException("专辑不存在");
        }
        album.setStatus(status);
        this.updateById(album);
    }
    /**
     * 分页查询可展示的专辑列表。
     */

    @Override
    public Page<AlbumVO> getAlbumList(Integer current, Integer size, String keyword) {
        // 构建查询条件
        LambdaQueryWrapper<Album> query = new LambdaQueryWrapper<>();
        query.eq(Album::getStatus, 1); // 只查询上架的专辑

        if (keyword != null && !keyword.isEmpty()) {
            query.and(wrapper -> wrapper
                    .like(Album::getTitle, keyword)
                    .or()
                    .like(Album::getArtist, keyword)
            );
        }

        query.orderByDesc(Album::getReleaseDate);

        // 分页查询
        Page<Album> page = new Page<>(current, size);
        this.page(page, query);

        // 转换VO
        Page<AlbumVO> voPage = new Page<>(current, size, page.getTotal());
        List<AlbumVO> voList = page.getRecords().stream().map(album -> {
            AlbumVO vo = new AlbumVO();
            BeanUtils.copyProperties(album, vo);
            return vo;
        }).collect(Collectors.toList());

        voPage.setRecords(voList);
        return voPage;
    }
    /**
     * 查询专辑详情及其歌曲列表。
     */

    @Override
    public AlbumDetailVO getAlbumDetail(Long id) {
        // 查询专辑
        Album album = this.getById(id);
        if (album == null) {
            throw new BusinessException("专辑不存在");
        }

        // 转换VO
        AlbumDetailVO vo = new AlbumDetailVO();
        BeanUtils.copyProperties(album, vo);

        // 查询歌曲列表
        LambdaQueryWrapper<Song> songQuery = new LambdaQueryWrapper<>();
        songQuery.eq(Song::getAlbumId, id);
        songQuery.orderByAsc(Song::getTrackNumber);

        List<Song> songs = songMapper.selectList(songQuery);
        List<SongVO> songVOList = songs.stream().map(song -> {
            SongVO songVO = new SongVO();
            BeanUtils.copyProperties(song, songVO);
            return songVO;
        }).collect(Collectors.toList());

        vo.setSongs(songVOList);
        return vo;
    }
}