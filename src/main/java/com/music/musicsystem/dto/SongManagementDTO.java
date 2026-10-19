package com.music.musicsystem.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 封装客户端提交的数据，并声明接口参数校验规则。
 */

@Data
public class SongManagementDTO {
    @NotNull(message = "专辑ID不能为空")
    private Long albumId;

    @NotBlank(message = "歌曲名称不能为空")
    @Size(max = 255, message = "歌曲名称不能超过255个字符")
    private String title;

    @NotBlank(message = "艺人名称不能为空")
    @Size(max = 255, message = "艺人名称不能超过255个字符")
    private String artist;

    @NotNull(message = "歌曲时长不能为空")
    @Min(value = 1, message = "歌曲时长必须大于0")
    private Integer duration;

    @Size(max = 1000, message = "音频地址不能超过1000个字符")
    private String audioUrl;

    @Size(max = 1000, message = "试听地址不能超过1000个字符")
    private String previewUrl;

    @Min(value = 0, message = "试听时长不能小于0")
    private Integer previewDuration;

    @NotNull(message = "曲序不能为空")
    @Min(value = 1, message = "曲序必须大于0")
    private Integer trackNumber;

    @Size(max = 10000, message = "歌词不能超过10000个字符")
    private String lyrics;
}