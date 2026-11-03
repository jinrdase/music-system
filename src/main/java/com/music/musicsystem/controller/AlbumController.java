package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.service.AlbumService;
import com.music.musicsystem.service.SongService;
import com.music.musicsystem.vo.AlbumDetailVO;
import com.music.musicsystem.vo.AlbumVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 处理面向用户的专辑和歌曲查询请求。
 */

@RestController
@RequestMapping("/api/album")
public class AlbumController {

    @Autowired
    private AlbumService albumService;

    @Autowired
    private SongService songService;

    /**
     * 分页查询专辑列表
     */
    @GetMapping("/list")
    public Result<Page<AlbumVO>> getAlbumList(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword
    ) {
        // 审查 L-14：分页 size 封顶，防止一次拖取全量数据
        Page<AlbumVO> page = albumService.getAlbumList(
                normalizeCurrent(current), normalizeSize(size), keyword);
        return Result.success(page);
    }

    static Integer normalizeCurrent(Integer current) {
        return (current == null || current < 1) ? 1 : current;
    }

    static Integer normalizeSize(Integer size) {
        return (size == null || size < 1) ? 10 : Math.min(size, 100);
    }

    /**
     * 获取专辑详情
     */
    @GetMapping("/{id}")
    public Result<AlbumDetailVO> getAlbumDetail(@PathVariable Long id) {
        AlbumDetailVO detail = albumService.getAlbumDetail(id);
        return Result.success(detail);
    }

    /**
     * 试听歌曲（增加播放次数）
     */
    @PostMapping("/song/{songId}/play")
    public Result<Void> playSong(@PathVariable Long songId) {
        songService.increasePlayCount(songId);
        return Result.success("播放成功", null);
    }
}