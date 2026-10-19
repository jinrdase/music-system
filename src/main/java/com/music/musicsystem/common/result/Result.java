package com.music.musicsystem.common.result;

import lombok.Data;

import java.io.Serializable;

/**
 * 封装接口统一响应字段及其构造方法。
 */

@Data
public class Result<T> implements Serializable {

    private Integer code;
    private String message;
    private T data;

    public Result() {}

    public Result(Integer code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    // 成功
    /**
     * 构造成功响应；具体数据或提示由重载参数决定。
     */
    public static <T> Result<T> success() {
        return new Result<>(200, "success", null);
    }
    /**
     * 构造成功响应；具体数据或提示由重载参数决定。
     */

    public static <T> Result<T> success(T data) {
        return new Result<>(200, "success", data);
    }
    /**
     * 构造成功响应；具体数据或提示由重载参数决定。
     */

    public static <T> Result<T> success(String message, T data) {
        return new Result<>(200, message, data);
    }

    // 失败
    /**
     * 构造失败响应；具体错误信息由重载参数决定。
     */
    public static <T> Result<T> fail() {
        return new Result<>(500, "操作失败", null);
    }
    /**
     * 构造失败响应；具体错误信息由重载参数决定。
     */

    public static <T> Result<T> fail(String message) {
        return new Result<>(500, message, null);
    }
    /**
     * 构造失败响应；具体错误信息由重载参数决定。
     */

    public static <T> Result<T> fail(Integer code, String message) {
        return new Result<>(code, message, null);
    }
}