package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import com.music.musicsystem.dto.AlbumManagementDTO;
import com.music.musicsystem.service.AlbumService;
import com.music.musicsystem.vo.AlbumVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import java.net.URI;

/**
 * 处理后台专辑创建、编辑、上架和查询请求。
 */

@RestController
@RequestMapping("/api/admin/albums")
public class AdminAlbumController {

    private final AlbumService albumService;

    public AdminAlbumController(AlbumService albumService) {
        this.albumService = albumService;
    }

    @GetMapping
    public Result<Page<AlbumVO>> list(@RequestParam(defaultValue = "1") Integer current,
                                      @RequestParam(defaultValue = "10") Integer size,
                                      @RequestParam(required = false) String keyword,
                                      HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(albumService.getAdminAlbumList(current, size, keyword));
    }

    @PostMapping
    public Result<Long> create(@Valid @RequestBody AlbumManagementDTO dto,
                               HttpServletRequest request) {
        requireAdmin(request);
        validateFlags(dto);
        return Result.success(albumService.createAlbum(dto));
    }

    @PutMapping("/{albumId}")
    public Result<Void> update(@PathVariable Long albumId,
                               @Valid @RequestBody AlbumManagementDTO dto,
                               HttpServletRequest request) {
        requireAdmin(request);
        validateFlags(dto);
        albumService.updateAlbum(albumId, dto);
        return Result.success("专辑信息已更新", null);
    }

    @PutMapping("/{albumId}/status")
    public Result<Void> changeStatus(@PathVariable Long albumId,
                                     @RequestParam Integer status,
                                     HttpServletRequest request) {
        requireAdmin(request);
        if (status == null || (status != 0 && status != 1)) {
            throw new BusinessException("商品状态只能是0（下架）或1（上架）");
        }
        albumService.changeAlbumStatus(albumId, status);
        return Result.success("商品状态已更新", null);
    }

    private void validateFlags(AlbumManagementDTO dto) {
        if (dto.getProductType() == null ||
                (!"PHYSICAL".equalsIgnoreCase(dto.getProductType()) && !"DIGITAL".equalsIgnoreCase(dto.getProductType()))) {
            throw new BusinessException("商品形态只能是PHYSICAL或DIGITAL");
        }
        if ("DIGITAL".equalsIgnoreCase(dto.getProductType()) &&
                (dto.getDigitalContentUrl() == null || dto.getDigitalContentUrl().isBlank())) {
            throw new BusinessException("数字商品必须配置内容地址");
        }
        if ("DIGITAL".equalsIgnoreCase(dto.getProductType())) {
            try {
                URI contentUri = URI.create(dto.getDigitalContentUrl().trim());
                if (!"https".equalsIgnoreCase(contentUri.getScheme()) || contentUri.getHost() == null) {
                    throw new BusinessException("数字内容地址必须是HTTPS私有下载地址");
                }
            } catch (IllegalArgumentException e) {
                throw new BusinessException("数字内容地址格式无效");
            }
        }
        if (dto.getStatus() == null || (dto.getStatus() != 0 && dto.getStatus() != 1)) {
            throw new BusinessException("商品状态只能是0（下架）或1（上架）");
        }
        if (dto.getIsLimited() == null || (dto.getIsLimited() != 0 && dto.getIsLimited() != 1)) {
            throw new BusinessException("限量标记只能是0或1");
        }
    }

    private void requireAdmin(HttpServletRequest request) {
        String role = (String) request.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role) && !"super_admin".equalsIgnoreCase(role)) {
            throw new BusinessException(403, "无权执行该操作");
        }
    }
}