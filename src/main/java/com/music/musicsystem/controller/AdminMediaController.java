package com.music.musicsystem.controller;

import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.common.result.Result;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

/**
 * 处理后台图片和音频文件上传请求。
 */

@RestController
@RequestMapping("/api/admin/media")
public class AdminMediaController {
    private static final long MAX_IMAGE_SIZE = 20L * 1024 * 1024;
    private static final long MAX_AUDIO_SIZE = 100L * 1024 * 1024;

    @Value("${music.upload.directory:${user.home}/music-system-uploads}")
    private String uploadDirectory;

    @PostMapping("/image")
    public Result<Map<String, String>> uploadImage(@RequestParam("file") MultipartFile file,
                                                    HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(store(file, "image", MAX_IMAGE_SIZE,
                Map.of("png", "image/png", "jpg", "image/jpeg", "jpeg", "image/jpeg", "webp", "image/webp")));
    }

    @PostMapping("/audio")
    public Result<Map<String, String>> uploadAudio(@RequestParam("file") MultipartFile file,
                                                    HttpServletRequest request) {
        requireAdmin(request);
        return Result.success(store(file, "audio", MAX_AUDIO_SIZE,
                Map.of("mp3", "audio/mpeg", "wav", "audio/wav", "ogg", "audio/ogg")));
    }

    private Map<String, String> store(MultipartFile file, String category, long maxSize,
                                      Map<String, String> supportedTypes) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException("请选择要上传的文件");
        }
        if (file.getSize() > maxSize) {
            throw new BusinessException("文件超过允许大小");
        }
        String originalName = StringUtils.cleanPath(file.getOriginalFilename() == null ? "" : file.getOriginalFilename());
        String extension = StringUtils.getFilenameExtension(originalName);
        if (extension == null) {
            throw new BusinessException("文件扩展名无效");
        }
        extension = extension.toLowerCase(Locale.ROOT);
        String expectedType = supportedTypes.get(extension);
        if (expectedType == null || file.getContentType() == null
                || !expectedType.equalsIgnoreCase(file.getContentType())) {
            throw new BusinessException("文件类型不受支持");
        }
        try (InputStream input = file.getInputStream()) {
            if (!hasExpectedSignature(input.readNBytes(12), extension)) {
                throw new BusinessException("文件内容与扩展名不匹配");
            }
        } catch (IOException e) {
            throw new BusinessException("无法读取上传文件");
        }
        Path root = Path.of(uploadDirectory).toAbsolutePath().normalize();
        String fileName = UUID.randomUUID().toString().replace("-", "") + "." + extension;
        Path target = root.resolve(category).resolve(fileName).normalize();
        if (!target.startsWith(root)) {
            throw new BusinessException("文件路径无效");
        }
        try {
            Files.createDirectories(target.getParent());
            file.transferTo(target);
        } catch (IOException e) {
            throw new BusinessException("文件保存失败");
        }
        return Map.of("url", "/media/" + category + "/" + fileName, "originalName", originalName);
    }

    boolean hasExpectedSignature(byte[] bytes, String extension) {
        return switch (extension) {
            case "png" -> startsWith(bytes, 0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a);
            case "jpg", "jpeg" -> startsWith(bytes, 0xff, 0xd8, 0xff);
            case "webp" -> startsWithAscii(bytes, "RIFF") && bytes.length >= 12
                    && new String(bytes, 8, 4, java.nio.charset.StandardCharsets.US_ASCII).equals("WEBP");
            case "wav" -> startsWithAscii(bytes, "RIFF") && bytes.length >= 12
                    && new String(bytes, 8, 4, java.nio.charset.StandardCharsets.US_ASCII).equals("WAVE");
            case "ogg" -> startsWithAscii(bytes, "OggS");
            case "mp3" -> startsWithAscii(bytes, "ID3") ||
                    (bytes.length >= 2 && (bytes[0] & 0xff) == 0xff && (bytes[1] & 0xe0) == 0xe0);
            default -> false;
        };
    }

    private boolean startsWith(byte[] bytes, int... prefix) {
        if (bytes.length < prefix.length) return false;
        for (int i = 0; i < prefix.length; i++) {
            if ((bytes[i] & 0xff) != prefix[i]) return false;
        }
        return true;
    }

    private boolean startsWithAscii(byte[] bytes, String prefix) {
        byte[] expected = prefix.getBytes(java.nio.charset.StandardCharsets.US_ASCII);
        if (bytes.length < expected.length) return false;
        for (int i = 0; i < expected.length; i++) {
            if (bytes[i] != expected[i]) return false;
        }
        return true;
    }

    private void requireAdmin(HttpServletRequest request) {
        String role = (String) request.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role) && !"super_admin".equalsIgnoreCase(role)) {
            throw new BusinessException(403, "无权上传媒体文件");
        }
    }
}