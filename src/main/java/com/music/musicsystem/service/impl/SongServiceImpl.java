package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.impl.ServiceImpl;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.dto.SongManagementDTO;
import com.music.musicsystem.entity.Album;
import com.music.musicsystem.entity.Song;
import com.music.musicsystem.mapper.AlbumMapper;
import com.music.musicsystem.mapper.SongMapper;
import com.music.musicsystem.service.SongService;
import com.music.musicsystem.vo.SongVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 实现歌曲查询、管理和播放统计业务。
 */

@Service
public class SongServiceImpl extends ServiceImpl<SongMapper, Song> implements SongService {

    @Autowired
    private AlbumMapper albumMapper;
    /**
     * 分页查询后台歌曲列表。
     */

    @Override
    public Page<SongVO> getAdminSongs(Long albumId, Integer current, Integer size) {
        ensureAlbumExists(albumId);
        Page<Song> page = this.page(new Page<>(current, size),
                new LambdaQueryWrapper<Song>().eq(Song::getAlbumId, albumId)
                        .orderByAsc(Song::getTrackNumber));
        Page<SongVO> result = new Page<>(current, size, page.getTotal());
        result.setRecords(page.getRecords().stream().map(song -> {
            SongVO vo = new SongVO();
            BeanUtils.copyProperties(song, vo);
            return vo;
        }).toList());
        return result;
    }
    /**
     * 根据管理请求创建歌曲。
     */

    @Override
    public Long createSong(SongManagementDTO dto) {
        ensureAlbumExists(dto.getAlbumId());
        // 审查 L-10：同专辑内曲序唯一
        ensureTrackNumberAvailable(dto.getAlbumId(), dto.getTrackNumber(), null);
        Song song = new Song();
        BeanUtils.copyProperties(dto, song);
        song.setTitle(dto.getTitle().trim());
        song.setArtist(dto.getArtist().trim());
        song.setPlayCount(0);
        this.save(song);
        return song.getId();
    }
    /**
     * 更新指定歌曲的信息。
     */

    @Override
    public void updateSong(Long songId, SongManagementDTO dto) {
        ensureAlbumExists(dto.getAlbumId());
        Song song = this.getById(songId);
        if (song == null) {
            throw new BusinessException("歌曲不存在");
        }
        // 审查 L-10：曲序唯一（排除自身）
        ensureTrackNumberAvailable(dto.getAlbumId(), dto.getTrackNumber(), songId);
        BeanUtils.copyProperties(dto, song);
        song.setTitle(dto.getTitle().trim());
        song.setArtist(dto.getArtist().trim());
        if (!this.updateById(song)) {
            throw new BusinessException("歌曲信息更新失败");
        }
    }

    private void ensureTrackNumberAvailable(Long albumId, Integer trackNumber, Long excludeSongId) {
        Long count = this.count(new LambdaQueryWrapper<Song>()
                .eq(Song::getAlbumId, albumId)
                .eq(Song::getTrackNumber, trackNumber)
                .ne(excludeSongId != null, Song::getId, excludeSongId));
        if (count != null && count > 0) {
            throw new BusinessException("该专辑已存在曲序为 " + trackNumber + " 的歌曲");
        }
    }

    private void ensureAlbumExists(Long albumId) {
        if (albumId == null || albumMapper.selectById(albumId) == null) {
            throw new BusinessException("专辑不存在");
        }
    }

    /**
     * 删除指定歌曲（逻辑删除）。
     */

    @Override
    public void deleteSong(Long songId) {
        Song song = this.getById(songId);
        if (song == null) {
            throw new BusinessException("歌曲不存在");
        }
        this.removeById(songId);
    }
    /**
     * 增加歌曲播放次数。
     */

    @Override
    public void increasePlayCount(Long songId) {
        Song song = this.getById(songId);
        if (song == null) {
            // 审查 L-12：歌曲不存在不再静默成功
            throw new BusinessException("歌曲不存在");
        }
        // 审查 L-12：下架专辑的歌曲不允许继续刷播放量
        Album album = albumMapper.selectById(song.getAlbumId());
        if (album == null || album.getStatus() == null || album.getStatus() != 1) {
            throw new BusinessException("该歌曲所属专辑已下架");
        }
        // 审查 L-12：条件更新原子自增，不再读改写整行回写
        this.update(new LambdaUpdateWrapper<Song>()
                .eq(Song::getId, songId)
                .setSql("play_count = play_count + 1"));
    }
}