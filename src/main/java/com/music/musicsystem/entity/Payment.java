package com.music.musicsystem.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 映射业务对象字段与数据库记录。
 */

@Data
@TableName("payment")
public class Payment {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String paymentNo; // 支付流水

    private Long orderId;

    private String orderNo;

    private Long userId;

    private BigDecimal amount; // 支付金额


    private Integer status; // 支付状态：0-待支付，1-支付成功-支付失败-已退

    private String transactionId; // 第三方交易号

    private String notifyData; // 支付回调数据

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    private LocalDateTime payTime; // 支付完成时间

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;
}