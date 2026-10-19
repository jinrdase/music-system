package com.music.musicsystem.common.exception;

import com.music.musicsystem.common.result.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 将应用异常转换为统一格式的 HTTP 响应。
 */

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    // 业务异常
    /**
     * 将业务异常转换为统一的失败响应。
     */
    @ExceptionHandler(BusinessException.class)
    public Result<?> handleBusinessException(BusinessException e) {
        log.error("业务异常：{}", e.getMessage());
        return Result.fail(e.getCode(), e.getMessage());
    }

    // 参数校验异常
    /**
     * 将参数校验错误转换为统一的失败响应。
     */
    @ExceptionHandler({MethodArgumentNotValidException.class, BindException.class})
    public Result<?> handleValidException(Exception e) {
        String message = "参数校验失败";
        if (e instanceof MethodArgumentNotValidException) {
            MethodArgumentNotValidException ex = (MethodArgumentNotValidException) e;
            if (ex.getBindingResult().hasErrors()) {
                message = ex.getBindingResult().getAllErrors().get(0).getDefaultMessage();
            }
        } else if (e instanceof BindException) {
            BindException ex = (BindException) e;
            if (ex.getBindingResult().hasErrors()) {
                message = ex.getBindingResult().getAllErrors().get(0).getDefaultMessage();
            }
        }
        log.error("参数校验异常：{}", message);
        return Result.fail(400, message);
    }

    // 系统异常
    /**
     * 处理未预期异常并返回统一错误响应。
     */
    @ExceptionHandler(Exception.class)
    public Result<?> handleException(Exception e) {
        log.error("系统发生未处理异常", e);
        return Result.fail("系统内部错误，请稍后重试");
    }
}