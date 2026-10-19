package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */

@Data
@TableName("admin_audit_log")
public class AdminAuditLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long operatorUserId;
    private String operatorRole;
    private String httpMethod;
    private String requestPath;
    private Integer responseStatus;
    private String clientIp;
    private LocalDateTime createdAt;
}