package com.music.musicsystem.common.exception;

import lombok.Getter;

/**
 * 表示可向接口调用方返回的业务异常。
 */

@Getter
public class BusinessException extends RuntimeException {

    private Integer code;

    public BusinessException(String message) {
        super(message);
        this.code = 500;
    }

    public BusinessException(Integer code, String message) {
        super(message);
        this.code = code;
    }
}