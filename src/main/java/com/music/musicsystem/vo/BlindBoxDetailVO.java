package com.music.musicsystem.vo;

import com.music.musicsystem.entity.BlindBoxPrize;
import lombok.Data;

import java.util.List;

/**
 * 封装接口返回给调用方的展示数据。
 */

@Data
public class BlindBoxDetailVO {
    private BlindBoxVO blindBox;
    private List<BlindBoxPrize> prizes;
}