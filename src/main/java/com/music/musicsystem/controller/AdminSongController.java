package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.SongManagementDTO;
import com.music.musicsystem.service.SongService;
import com.music.musicsystem.vo.SongVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

/**
 * 处理后台歌曲创建、编辑和查询请求。
 */

@RestController
@RequestMapping("/api/admin/songs")
public class AdminSongController {

    private final SongService songService;

    public AdminSongController(SongService songService) {
        this.songService = songService;
    }

    @GetMapping
    public Result<Page<SongVO>> list(@RequestParam Long albumId,
                                     @RequestParam(defaultValue = "1") Integer current,
                                     @RequestParam(defaultValue = "20") Integer size,
                                     HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(songService.getAdminSongs(albumId, current, size));
    }

    @PostMapping
    public Result<Long> create(@Valid @RequestBody SongManagementDTO dto,
                               HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(songService.createSong(dto));
    }

    @PutMapping("/{songId}")
    public Result<Void> update(@PathVariable Long songId,
                               @Valid @RequestBody SongManagementDTO dto,
                               HttpServletRequest request) {
        requireAdmin(request);
        songService.updateSong(songId, dto);
        return Result.success("歌曲信息已更新", null);
    }

    private void requireAdmin(HttpServletRequest request) {
        String role = (String) request.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role) && !"super_admin".equalsIgnoreCase(role)) {
            throw new BusinessException(403, "无权执行该操作");
        }
    }
}