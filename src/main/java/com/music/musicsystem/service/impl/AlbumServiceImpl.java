package com.music.musicsystem.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.impl.ServiceImpl;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.entity.Album;
import com.music.musicsystem.dto.AlbumManagementDTO;
import com.music.musicsystem.entity.Song;
import com.music.musicsystem.mapper.AlbumMapper;
import com.music.musicsystem.mapper.SongMapper;
import com.music.musicsystem.service.AlbumService;
import com.music.musicsystem.util.RedisUtil;
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

    @Autowired
    private RedisUtil redisUtil;

    /** 订单链路的 Redis 库存预扣键前缀（与 OrderServiceImpl 保持一致，审查 M-10） */
    private static final String STOCK_PREFIX = "album:stock:";
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
     * 只更新允许编辑的字段（审查 M-9：不做整行回写，避免覆盖并发下单变更的 stock/sales）；
     * 商品形态与数字内容地址创建后锁定（审查 M-11），防止存量订单/购物车语义漂移；
     * 库存变更后删除 Redis 预扣键，保证补货/减库存即时生效（审查 M-10）。
     */
    @Override
    public void updateAlbum(Long albumId, AlbumManagementDTO dto) {
        Album album = this.getById(albumId);
        if (album == null) {
            throw new BusinessException("专辑不存在");
        }
        boolean stockChanged = dto.getStock() != null && !dto.getStock().equals(album.getStock());

        LambdaUpdateWrapper<Album> wrapper = new LambdaUpdateWrapper<Album>()
                .eq(Album::getId, albumId)
                .set(Album::getTitle, dto.getTitle().trim())
                .set(Album::getArtist, dto.getArtist().trim())
                .set(Album::getCoverUrl, dto.getCoverUrl())
                .set(Album::getDescription, dto.getDescription())
                .set(Album::getReleaseDate, dto.getReleaseDate())
                .set(Album::getPrice, dto.getPrice())
                .set(Album::getIsLimited, dto.getIsLimited())
                .set(Album::getStatus, dto.getStatus());
        if (stockChanged) {
            wrapper.set(Album::getStock, dto.getStock());
        }
        if (!this.update(wrapper)) {
            throw new BusinessException("专辑信息更新失败");
        }
        if (stockChanged) {
            // 下次下单时从 DB 重新加载，保证补货/减库存对 Redis 预扣层生效
            redisUtil.delete(STOCK_PREFIX + albumId);
        }
    }
    /**
     * 修改指定专辑的上架状态（条件化字段更新，不回写 stock/sales，审查 M-9）。
     */

    @Override
    public void changeAlbumStatus(Long albumId, Integer status) {
        Album album = this.getById(albumId);
        if (album == null) {
            throw new BusinessException("专辑不存在");
        }
        if (status == null || (status != 0 && status != 1)) {
            throw new BusinessException("状态值无效");
        }
        this.update(new LambdaUpdateWrapper<Album>()
                .eq(Album::getId, albumId)
                .set(Album::getStatus, status)
        );
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
        // 审查 L-11：与列表/购物车/下单的 status=1 口径一致，下架专辑详情不再可访问
        if (album.getStatus() == null || album.getStatus() != 1) {
            throw new BusinessException("该专辑已下架");
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