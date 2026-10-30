/*
 Navicat Premium Dump SQL

 Source Server         : music_system
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : localhost:3307
 Source Schema         : music_system

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 19/10/2026 21:36:18
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for album
-- ----------------------------
DROP TABLE IF EXISTS `album`;
CREATE TABLE `album`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '专辑ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '专辑名称',
  `artist` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '艺术家/歌手',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '专辑描述',
  `release_date` date NOT NULL COMMENT '发行日期',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存数量',
  `sales` int NOT NULL DEFAULT 0 COMMENT '销量',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-下架，1-上架',
  `is_limited` tinyint NOT NULL DEFAULT 0 COMMENT '是否限量：0-否，1-是',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_artist`(`artist` ASC) USING BTREE,
  INDEX `idx_release_date`(`release_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专辑表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of album
-- ----------------------------
INSERT INTO `album` VALUES (1, '夜航星', '星辰乐队', 'https://example.com/cover1.jpg', '一张充满未来感的电子流行专辑', '2026-01-15', 128.00, 1001, -1, 1, 0, 0, '2026-10-15 10:59:01', '2026-10-15 12:58:00');
INSERT INTO `album` VALUES (2, '限量珍藏版-追光者', '月影', 'https://example.com/cover2.jpg', '限量发行500张，含签名海报', '2026-03-20', 298.00, 500, 0, 1, 1, 0, '2026-10-15 10:59:01', '2026-10-15 10:59:01');
INSERT INTO `album` VALUES (3, '城市回声', 'Urban Beats', 'https://example.com/cover3.jpg', '都市hip-hop合辑', '2026-02-10', 98.00, 2000, 0, 1, 0, 0, '2026-10-15 10:59:01', '2026-10-15 10:59:01');

-- ----------------------------
-- Table structure for blind_box
-- ----------------------------
DROP TABLE IF EXISTS `blind_box`;
CREATE TABLE `blind_box`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '盲盒名称',
  `album_id` bigint NOT NULL COMMENT '关联专辑ID',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `price` decimal(10, 2) NOT NULL COMMENT '单抽价格',
  `total_count` int NOT NULL COMMENT '总库存',
  `remain_count` int NOT NULL COMMENT '剩余库存',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-下架，1-上架',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_album_id`(`album_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '盲盒配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blind_box
-- ----------------------------
INSERT INTO `blind_box` VALUES (1, '经典金曲盲盒', 1, '抽取你最喜欢的经典金曲！SSR概率1%，SR概率5%，R概率20%，N概率74%', 10.00, 10000, 10000, 1, '2026-10-15 16:09:55', '2026-10-15 16:09:55');

-- ----------------------------
-- Table structure for blind_box_prize
-- ----------------------------
DROP TABLE IF EXISTS `blind_box_prize`;
CREATE TABLE `blind_box_prize`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `box_id` bigint NOT NULL COMMENT '盲盒ID',
  `prize_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '奖品名称',
  `prize_level` tinyint NOT NULL COMMENT '稀有度：1-SSR，2-SR，3-R，4-N',
  `probability` decimal(5, 2) NOT NULL COMMENT '基础概率（%）',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '奖品图片',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '奖品描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_box_id`(`box_id` ASC) USING BTREE,
  INDEX `idx_level`(`prize_level` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '盲盒奖品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blind_box_prize
-- ----------------------------
INSERT INTO `blind_box_prize` VALUES (1, 1, '限定签名专辑', 1, 0.50, '/images/prize_ssr_1.jpg', 'SSR稀有度，艺术家亲笔签名专辑', '2026-10-15 16:09:55');
INSERT INTO `blind_box_prize` VALUES (2, 1, '演唱会VIP门票', 1, 0.50, '/images/prize_ssr_2.jpg', 'SSR稀有度，前排VIP座位', '2026-10-15 16:09:55');
INSERT INTO `blind_box_prize` VALUES (3, 1, '精装CD套装', 2, 2.50, '/images/prize_sr_1.jpg', 'SR稀有度，限量精装版', '2026-10-15 16:09:55');
INSERT INTO `blind_box_prize` VALUES (4, 1, '艺术家海报', 2, 2.50, '/images/prize_sr_2.jpg', 'SR稀有度，官方周边海报', '2026-10-15 16:09:55');
INSERT INTO `blind_box_prize` VALUES (5, 1, '数字专辑', 3, 10.00, '/images/prize_r_1.jpg', 'R稀有度，高品质数字专辑', '2026-10-15 16:09:55');
INSERT INTO `blind_box_prize` VALUES (6, 1, '专辑徽章', 3, 10.00, '/images/prize_r_2.jpg', 'R稀有度，精美收藏徽章', '2026-10-15 16:09:55');
INSERT INTO `blind_box_prize` VALUES (7, 1, '专辑试听券', 4, 37.00, '/images/prize_n_1.jpg', 'N稀有度，7天试听权限', '2026-10-15 16:09:55');
INSERT INTO `blind_box_prize` VALUES (8, 1, '音乐壁纸', 4, 37.00, '/images/prize_n_2.jpg', 'N稀有度，高清手机壁纸', '2026-10-15 16:09:55');

-- ----------------------------
-- Table structure for draw_record
-- ----------------------------
DROP TABLE IF EXISTS `draw_record`;
CREATE TABLE `draw_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `box_id` bigint NOT NULL COMMENT '盲盒ID',
  `prize_id` bigint NOT NULL COMMENT '奖品ID',
  `prize_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '奖品名称',
  `prize_level` tinyint NOT NULL COMMENT '稀有度',
  `draw_count` int NOT NULL COMMENT '当前累计抽数',
  `is_guarantee` tinyint NOT NULL DEFAULT 0 COMMENT '是否保底：0-否，1-是',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_box_id`(`box_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '抽奖记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of draw_record
-- ----------------------------

-- ----------------------------
-- Table structure for order_info
-- ----------------------------
DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `album_id` bigint NOT NULL COMMENT '专辑ID',
  `album_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '专辑名称',
  `album_cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '专辑封面',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '购买数量',
  `price` decimal(10, 2) NOT NULL COMMENT '单价',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '总金额',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '订单状态：0-待支付，1-已支付，2-已完成，3-已取消，4-已发货，5-已退款',
  `receiver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货人手机',
  `receiver_province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省',
  `receiver_city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '市',
  `receiver_district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '区',
  `receiver_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '取消时间',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_album_id`(`album_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_expire_time`(`expire_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_info
-- ----------------------------
INSERT INTO `order_info` VALUES (1, 'ORD17920368989504778', 1, 1, '夜航星', 'https://example.com/cover1.jpg', 1, 128.00, 128.00, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-15 12:17:00', '2026-10-15 12:16:39', NULL, 0, '2026-10-15 12:01:39', '2026-10-15 12:01:39');
INSERT INTO `order_info` VALUES (2, 'ORD17920393271626932', 1, 1, '夜航星', 'https://example.com/cover1.jpg', 1, 128.00, 128.00, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-15 12:58:00', '2026-10-15 12:57:07', NULL, 0, '2026-10-15 12:42:07', '2026-10-15 12:42:07');
INSERT INTO `order_info` VALUES (3, 'ORD20261015124229573', 1, 1, '周杰伦的床边故事', 'https://example.com/cover.jpg', 1, 199.00, 199.00, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-15 12:44:00', '2026-10-15 12:38:25', NULL, 0, '2026-10-15 12:42:29', '2026-10-15 12:43:25');

-- ----------------------------
-- Table structure for order_logistics
-- ----------------------------
DROP TABLE IF EXISTS `order_logistics`;
CREATE TABLE `order_logistics`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `carrier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `tracking_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `shipped_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_logistics_order_id`(`order_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_order_logistics_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_order_logistics_tracking_no`(`tracking_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_logistics
-- ----------------------------

-- ----------------------------
-- Table structure for payment
-- ----------------------------
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '支付ID',
  `payment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '支付流水号',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `amount` decimal(10, 2) NOT NULL COMMENT '支付金额',
  `status` tinyint NULL DEFAULT 0 COMMENT '支付状态 0-待支付 1-支付成功 2-支付失败 3-已退款',
  `transaction_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '第三方交易号',
  `notify_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '支付回调数据',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付完成时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_payment_no`(`payment_no` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '支付记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payment
-- ----------------------------

-- ----------------------------
-- Table structure for refund_application
-- ----------------------------
DROP TABLE IF EXISTS `refund_application`;
CREATE TABLE `refund_application`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `refund_amount` decimal(10, 2) NOT NULL,
  `reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `images` json NULL,
  `return_carrier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `return_tracking_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0 pending, 1 approved, 2 rejected, 3 refunded',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `auditor_id` bigint NULL DEFAULT NULL,
  `audit_time` datetime NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_refund_application_user`(`user_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_refund_application_order`(`order_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_refund_application_status`(`status` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_application
-- ----------------------------

-- ----------------------------
-- Table structure for shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `shopping_cart`;
CREATE TABLE `shopping_cart`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `album_id` bigint NOT NULL COMMENT '专辑ID',
  `album_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '专辑名称',
  `album_cover` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '专辑封面',
  `price` decimal(10, 2) NOT NULL COMMENT '单价',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '数量',
  `is_selected` tinyint(1) NULL DEFAULT 1 COMMENT '是否选中 0-否 1-是',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_album_id`(`album_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '购物车表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shopping_cart
-- ----------------------------

-- ----------------------------
-- Table structure for song
-- ----------------------------
DROP TABLE IF EXISTS `song`;
CREATE TABLE `song`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '歌曲ID',
  `album_id` bigint NOT NULL COMMENT '所属专辑ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '歌曲名称',
  `artist` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '演唱者',
  `duration` int NOT NULL COMMENT '时长(秒)',
  `audio_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '完整音频文件URL',
  `preview_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '试听音频URL',
  `preview_duration` int NOT NULL DEFAULT 30 COMMENT '试听时长(秒)',
  `track_number` int NOT NULL COMMENT '曲目序号',
  `lyrics` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '歌词',
  `play_count` int NOT NULL DEFAULT 0 COMMENT '播放次数',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_album_id`(`album_id` ASC) USING BTREE,
  INDEX `idx_title`(`title` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '歌曲表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of song
-- ----------------------------
INSERT INTO `song` VALUES (1, 1, '星际旅行', '星辰乐队', 245, 'https://example.com/audio/song1.mp3', 'https://example.com/audio/song1_preview.mp3', 30, 1, NULL, 1, 0, '2026-10-15 10:59:01', '2026-10-15 10:59:01');
INSERT INTO `song` VALUES (2, 1, '夜色温柔', '星辰乐队', 198, 'https://example.com/audio/song2.mp3', 'https://example.com/audio/song2_preview.mp3', 30, 2, NULL, 0, 0, '2026-10-15 10:59:01', '2026-10-15 10:59:01');
INSERT INTO `song` VALUES (3, 1, '未来已来', '星辰乐队', 223, 'https://example.com/audio/song3.mp3', 'https://example.com/audio/song3_preview.mp3', 30, 3, NULL, 0, 0, '2026-10-15 10:59:01', '2026-10-15 10:59:01');
INSERT INTO `song` VALUES (4, 2, '追光', '月影', 267, 'https://example.com/audio/song4.mp3', 'https://example.com/audio/song4_preview.mp3', 30, 1, NULL, 0, 0, '2026-10-15 10:59:02', '2026-10-15 10:59:02');
INSERT INTO `song` VALUES (5, 2, '晨曦', '月影', 201, 'https://example.com/audio/song5.mp3', 'https://example.com/audio/song5_preview.mp3', 30, 2, NULL, 0, 0, '2026-10-15 10:59:02', '2026-10-15 10:59:02');

-- ----------------------------
-- Table structure for stock_log
-- ----------------------------
DROP TABLE IF EXISTS `stock_log`;
CREATE TABLE `stock_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `album_id` bigint NOT NULL COMMENT '专辑ID',
  `quantity` int NOT NULL COMMENT '数量（正数为扣减，负数为恢复）',
  `before_stock` int NOT NULL COMMENT '操作前库存',
  `after_stock` int NOT NULL COMMENT '操作后库存',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联订单号',
  `type` tinyint NOT NULL COMMENT '类型：1-下单扣减，2-取消恢复，3-超时恢复',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_album_id`(`album_id` ASC) USING BTREE,
  INDEX `idx_order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '库存流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stock_log
-- ----------------------------
INSERT INTO `stock_log` VALUES (1, 1, 1, 1000, 999, 'ORD17920368989504778', 1, '用户下单扣减库存', '2026-10-15 12:01:38');
INSERT INTO `stock_log` VALUES (2, 1, -1, 999, 1000, 'ORD17920368989504778', 2, '用户取消订单恢复库存', '2026-10-15 12:17:00');
INSERT INTO `stock_log` VALUES (3, 1, 1, 1000, 999, 'ORD17920393271626932', 1, '用户下单扣减库存', '2026-10-15 12:42:07');
INSERT INTO `stock_log` VALUES (4, 1, -1, 999, 1000, 'ORD20261015124229573', 2, '用户取消订单恢复库存', '2026-10-15 12:44:00');
INSERT INTO `stock_log` VALUES (5, 1, -1, 1000, 1001, 'ORD17920393271626932', 2, '用户取消订单恢复库存', '2026-10-15 12:58:00');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user' COMMENT '角色：admin-管理员，user-普通用户',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `uk_phone`(`phone` ASC) USING BTREE,
  UNIQUE INDEX `uk_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'testuser', '0c9023f5706d3d5defee107ba6c12d99', '测试用户', '13800138000', 'test@example.com', NULL, 1, 'user', 0, '2026-10-15 10:05:57', '2026-10-15 10:05:57');

-- ----------------------------
-- Table structure for user_address
-- ----------------------------
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `receiver_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '城市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '区县',
  `detail_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '详细地址',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '是否默认 0-否 1-是',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_is_default`(`is_default` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_address
-- ----------------------------

-- ----------------------------
-- Table structure for user_draw_stat
-- ----------------------------
DROP TABLE IF EXISTS `user_draw_stat`;
CREATE TABLE `user_draw_stat`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `box_id` bigint NOT NULL,
  `total_count` int NOT NULL DEFAULT 0 COMMENT '总抽数',
  `sr_count` int NOT NULL DEFAULT 0 COMMENT '距离上次SR的抽数',
  `ssr_count` int NOT NULL DEFAULT 0 COMMENT '距离上次SSR的抽数',
  `last_draw_time` datetime NULL DEFAULT NULL COMMENT '最后抽奖时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_box`(`user_id` ASC, `box_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户抽奖统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_draw_stat
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
