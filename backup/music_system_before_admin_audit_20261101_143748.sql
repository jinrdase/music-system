-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: music_system
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `music_system`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `music_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `music_system`;

--
-- Table structure for table `album`
--

DROP TABLE IF EXISTS `album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `album` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '专辑ID',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '专辑名称',
  `artist` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '艺术家/歌手',
  `cover_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图片URL',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '专辑描述',
  `release_date` date NOT NULL COMMENT '发行日期',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `stock` int NOT NULL DEFAULT '0' COMMENT '库存数量',
  `sales` int NOT NULL DEFAULT '0' COMMENT '销量',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-下架，1-上架',
  `is_limited` tinyint NOT NULL DEFAULT '0' COMMENT '是否限量：0-否，1-是',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `product_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PHYSICAL' COMMENT 'PHYSICAL or DIGITAL',
  `digital_content_url` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Private digital delivery target',
  PRIMARY KEY (`id`),
  KEY `idx_artist` (`artist`),
  KEY `idx_release_date` (`release_date`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='专辑表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album`
--

LOCK TABLES `album` WRITE;
/*!40000 ALTER TABLE `album` DISABLE KEYS */;
INSERT INTO `album` VALUES (1,'夜航星','星辰乐队','https://example.com/cover1.jpg','一张充满未来感的电子流行专辑','2026-01-15',128.00,1001,-1,1,0,0,'2026-10-15 10:59:01','2026-10-15 12:58:00','PHYSICAL',NULL),(2,'限量珍藏版-追光者','月影','https://example.com/cover2.jpg','限量发行500张，含签名海报','2026-03-20',298.00,495,5,1,1,0,'2026-10-15 10:59:01','2026-11-01 14:36:19','PHYSICAL',NULL),(3,'城市回声','Urban Beats','https://example.com/cover3.jpg','都市hip-hop合辑','2026-02-10',98.00,2000,0,1,0,0,'2026-10-15 10:59:01','2026-10-15 10:59:01','PHYSICAL',NULL);
/*!40000 ALTER TABLE `album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blind_box`
--

DROP TABLE IF EXISTS `blind_box`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blind_box` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '盲盒名称',
  `album_id` bigint NOT NULL COMMENT '关联专辑ID',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `price` decimal(10,2) NOT NULL COMMENT '单抽价格',
  `total_count` int NOT NULL COMMENT '总库存',
  `remain_count` int NOT NULL COMMENT '剩余库存',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-下架，1-上架',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_album_id` (`album_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='盲盒配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blind_box`
--

LOCK TABLES `blind_box` WRITE;
/*!40000 ALTER TABLE `blind_box` DISABLE KEYS */;
INSERT INTO `blind_box` VALUES (1,'经典金曲盲盒',1,'抽取你最喜欢的经典金曲！SSR概率1%，SR概率5%，R概率20%，N概率74%',10.00,10000,9999,1,'2026-10-15 16:09:55','2026-11-01 13:35:00');
/*!40000 ALTER TABLE `blind_box` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blind_box_prize`
--

DROP TABLE IF EXISTS `blind_box_prize`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blind_box_prize` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `box_id` bigint NOT NULL COMMENT '盲盒ID',
  `prize_name` varchar(100) NOT NULL COMMENT '奖品名称',
  `prize_level` tinyint NOT NULL COMMENT '稀有度：1-SSR，2-SR，3-R，4-N',
  `probability` decimal(5,2) NOT NULL COMMENT '基础概率（%）',
  `image_url` varchar(255) DEFAULT NULL COMMENT '奖品图片',
  `description` varchar(500) DEFAULT NULL COMMENT '奖品描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_box_id` (`box_id`),
  KEY `idx_level` (`prize_level`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='盲盒奖品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blind_box_prize`
--

LOCK TABLES `blind_box_prize` WRITE;
/*!40000 ALTER TABLE `blind_box_prize` DISABLE KEYS */;
INSERT INTO `blind_box_prize` VALUES (1,1,'限定签名专辑',1,0.50,'/images/prize_ssr_1.jpg','SSR稀有度，艺术家亲笔签名专辑','2026-10-15 16:09:55'),(2,1,'演唱会VIP门票',1,0.50,'/images/prize_ssr_2.jpg','SSR稀有度，前排VIP座位','2026-10-15 16:09:55'),(3,1,'精装CD套装',2,2.50,'/images/prize_sr_1.jpg','SR稀有度，限量精装版','2026-10-15 16:09:55'),(4,1,'艺术家海报',2,2.50,'/images/prize_sr_2.jpg','SR稀有度，官方周边海报','2026-10-15 16:09:55'),(5,1,'数字专辑',3,10.00,'/images/prize_r_1.jpg','R稀有度，高品质数字专辑','2026-10-15 16:09:55'),(6,1,'专辑徽章',3,10.00,'/images/prize_r_2.jpg','R稀有度，精美收藏徽章','2026-10-15 16:09:55'),(7,1,'专辑试听券',4,37.00,'/images/prize_n_1.jpg','N稀有度，7天试听权限','2026-10-15 16:09:55'),(8,1,'音乐壁纸',4,37.00,'/images/prize_n_2.jpg','N稀有度，高清手机壁纸','2026-10-15 16:09:55');
/*!40000 ALTER TABLE `blind_box_prize` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `draw_record`
--

DROP TABLE IF EXISTS `draw_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `draw_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `box_id` bigint NOT NULL COMMENT '盲盒ID',
  `prize_id` bigint NOT NULL COMMENT '奖品ID',
  `prize_name` varchar(100) NOT NULL COMMENT '奖品名称',
  `prize_level` tinyint NOT NULL COMMENT '稀有度',
  `draw_count` int NOT NULL COMMENT '当前累计抽数',
  `is_guarantee` tinyint NOT NULL DEFAULT '0' COMMENT '是否保底：0-否，1-是',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `probability_at_draw` decimal(10,6) DEFAULT NULL COMMENT 'Configured probability captured for audit',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_box_id` (`box_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='抽奖记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `draw_record`
--

LOCK TABLES `draw_record` WRITE;
/*!40000 ALTER TABLE `draw_record` DISABLE KEYS */;
INSERT INTO `draw_record` VALUES (1,14,1,5,'数字专辑',3,2,0,'2026-11-01 13:34:37',10.000000);
/*!40000 ALTER TABLE `draw_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_info`
--

DROP TABLE IF EXISTS `order_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `album_id` bigint NOT NULL COMMENT '专辑ID',
  `album_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '专辑名称',
  `album_cover` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '专辑封面',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '购买数量',
  `price` decimal(10,2) NOT NULL COMMENT '单价',
  `total_amount` decimal(10,2) NOT NULL COMMENT '总金额',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '订单状态：0-待支付，1-已支付，2-已取消，3-已完成',
  `receiver_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收货人手机',
  `receiver_province` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '省',
  `receiver_city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '市',
  `receiver_district` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '区',
  `receiver_address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '详细地址',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `product_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PHYSICAL' COMMENT 'Product type captured at order creation',
  `order_type` tinyint NOT NULL DEFAULT '1' COMMENT '订单形态：1-专辑订单，2-盲盒订单',
  `blind_box_id` bigint DEFAULT NULL COMMENT '盲盒订单关联的盲盒ID',
  `draw_count` int DEFAULT NULL COMMENT '盲盒订单抽取次数（1或10）',
  `draw_summary` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '盲盒抽取结果摘要',
  `digital_content_accessed_at` datetime DEFAULT NULL COMMENT '数字内容首次取阅时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_album_id` (`album_id`),
  KEY `idx_status` (`status`),
  KEY `idx_expire_time` (`expire_time`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_info`
--

LOCK TABLES `order_info` WRITE;
/*!40000 ALTER TABLE `order_info` DISABLE KEYS */;
INSERT INTO `order_info` VALUES (1,'ORD17920368989504778',1,1,'夜航星','https://example.com/cover1.jpg',1,128.00,128.00,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-10-15 12:17:00','2026-10-15 12:16:39',NULL,0,'2026-10-15 12:01:39','2026-10-15 12:01:39','PHYSICAL',1,NULL,NULL,NULL,NULL),(2,'ORD17920393271626932',1,1,'夜航星','https://example.com/cover1.jpg',1,128.00,128.00,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-10-15 12:58:00','2026-10-15 12:57:07',NULL,0,'2026-10-15 12:42:07','2026-10-15 12:42:07','PHYSICAL',1,NULL,NULL,NULL,NULL),(3,'ORD20261015124229573',1,1,'周杰伦的床边故事','https://example.com/cover.jpg',1,199.00,199.00,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-10-15 12:44:00','2026-10-15 12:38:25',NULL,0,'2026-10-15 12:42:29','2026-10-15 12:43:25','PHYSICAL',1,NULL,NULL,NULL,NULL),(4,'ORD1793510384343394',6,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',2,298.00,596.00,3,'测试收件人甲','13800138001','北京市','北京市','海淀区','测试路2号',NULL,'2026-11-01 13:35:00','2026-11-01 13:34:46','QA流程',0,'2026-11-01 13:19:46','2026-11-01 13:35:00','PHYSICAL',1,NULL,NULL,NULL,NULL),(5,'BB1793510386330849',6,1,'经典金曲盲盒',NULL,1,10.00,10.00,3,'测试收件人甲','13800138001','北京市','北京市','海淀区','测试路2号',NULL,'2026-11-01 13:35:00','2026-11-01 13:34:46','QA盲盒',0,'2026-11-01 13:19:46','2026-11-01 13:35:00','PHYSICAL',2,1,1,NULL,NULL),(6,'ORD17935106110857310',9,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',1,298.00,298.00,3,'测试用户','13800001234','浙江省','杭州市','西湖区','测试路一号',NULL,'2026-11-01 13:23:31','2026-11-01 13:38:31','QA temporary isolation test',0,'2026-11-01 13:23:31','2026-11-01 13:23:31','PHYSICAL',1,NULL,NULL,NULL,NULL),(7,'ORD17935112591385715',13,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',1,298.00,298.00,1,'流程测试','13800001234','浙江省','杭州市','西湖区','测试路二号','2026-11-01 13:34:20',NULL,'2026-11-01 13:49:20','QA simulated payment flow',0,'2026-11-01 13:34:20','2026-11-01 13:34:19','PHYSICAL',1,NULL,NULL,NULL,NULL),(8,'BB17935112771504876',14,1,'经典金曲盲盒',NULL,1,10.00,10.00,1,'盲盒测试','13800001234','浙江省','杭州市','西湖区','测试路三号','2026-11-01 13:34:37',NULL,'2026-11-01 13:49:37','QA paid draw',0,'2026-11-01 13:34:37','2026-11-01 13:34:37','PHYSICAL',2,1,1,'R·数字专辑',NULL),(9,'ORD17935145236219585',19,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',1,298.00,298.00,1,'E2E 测试用户','13800001234','浙江省','杭州市','西湖区','自动化测试路 1 号','2026-11-01 14:28:44',NULL,'2026-11-01 14:43:44',NULL,0,'2026-11-01 14:28:44','2026-11-01 14:28:44','PHYSICAL',1,NULL,NULL,NULL,NULL),(10,'ORD17935147595341113',20,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',1,298.00,298.00,1,'E2E 测试用户','13800001234','浙江省','杭州市','西湖区','自动化测试路 1 号','2026-11-01 14:32:40',NULL,'2026-11-01 14:47:40',NULL,0,'2026-11-01 14:32:40','2026-11-01 14:32:39','PHYSICAL',1,NULL,NULL,NULL,NULL),(11,'ORD17935148509098833',21,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',1,298.00,298.00,1,'E2E 测试用户','13800001234','浙江省','杭州市','西湖区','自动化测试路 1 号','2026-11-01 14:34:12',NULL,'2026-11-01 14:49:11',NULL,0,'2026-11-01 14:34:11','2026-11-01 14:34:11','PHYSICAL',1,NULL,NULL,NULL,NULL),(12,'ORD17935149793163346',22,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',1,298.00,298.00,1,'E2E 测试用户','13800001234','浙江省','杭州市','西湖区','自动化测试路 1 号','2026-11-01 14:36:20',NULL,'2026-11-01 14:51:19',NULL,0,'2026-11-01 14:36:19','2026-11-01 14:36:20','PHYSICAL',1,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `order_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `order_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `album_id` bigint NOT NULL COMMENT '专辑ID',
  `album_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '专辑名称快照',
  `album_cover` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '专辑封面快照',
  `price` decimal(10,2) NOT NULL COMMENT '成交单价快照',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '购买数量',
  `subtotal` decimal(10,2) NOT NULL COMMENT '商品小计',
  `product_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PHYSICAL' COMMENT '商品形态快照：PHYSICAL-实物，DIGITAL-数字',
  `digital_content_accessed_at` datetime DEFAULT NULL COMMENT '数字内容首次取阅时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_order_no` (`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单商品明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,4,'ORD1793510384343394',2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,2,596.00,'PHYSICAL',NULL,0,'2026-11-01 13:19:46','2026-11-01 13:19:46'),(2,6,'ORD17935106110857310',2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,298.00,'PHYSICAL',NULL,0,'2026-11-01 13:23:31','2026-11-01 13:23:31'),(3,7,'ORD17935112591385715',2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,298.00,'PHYSICAL',NULL,0,'2026-11-01 13:34:20','2026-11-01 13:34:20'),(4,9,'ORD17935145236219585',2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,298.00,'PHYSICAL',NULL,0,'2026-11-01 14:28:44','2026-11-01 14:28:44'),(5,10,'ORD17935147595341113',2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,298.00,'PHYSICAL',NULL,0,'2026-11-01 14:32:40','2026-11-01 14:32:40'),(6,11,'ORD17935148509098833',2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,298.00,'PHYSICAL',NULL,0,'2026-11-01 14:34:11','2026-11-01 14:34:11'),(7,12,'ORD17935149793163346',2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,298.00,'PHYSICAL',NULL,0,'2026-11-01 14:36:19','2026-11-01 14:36:19');
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_logistics`
--

DROP TABLE IF EXISTS `order_logistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_logistics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `order_no` varchar(64) NOT NULL,
  `carrier` varchar(100) NOT NULL,
  `tracking_no` varchar(100) NOT NULL,
  `shipped_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_logistics_order_id` (`order_id`),
  UNIQUE KEY `uk_order_logistics_order_no` (`order_no`),
  KEY `idx_order_logistics_tracking_no` (`tracking_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_logistics`
--

LOCK TABLES `order_logistics` WRITE;
/*!40000 ALTER TABLE `order_logistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_logistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '支付ID',
  `payment_no` varchar(50) NOT NULL COMMENT '支付流水号',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `order_no` varchar(50) NOT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `amount` decimal(10,2) NOT NULL COMMENT '支付金额',
  `status` tinyint DEFAULT '0' COMMENT '支付状态 0-待支付 1-支付成功 2-支付失败 3-已退款',
  `transaction_id` varchar(100) DEFAULT NULL COMMENT '第三方交易号',
  `notify_data` text COMMENT '支付回调数据',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `pay_time` datetime DEFAULT NULL COMMENT '支付完成时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_payment_no` (`payment_no`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (3,'PAY17935112595623FE3A523',7,'ORD17935112591385715',13,298.00,1,'MOCK1793511259596','mock-pay','2026-11-01 13:34:20','2026-11-01 13:34:20','2026-11-01 13:34:20',0),(4,'PAY1793511277183A7C2BFF1',8,'BB17935112771504876',14,10.00,1,'MOCK1793511277207','mock-pay','2026-11-01 13:34:37','2026-11-01 13:34:37','2026-11-01 13:34:37',0),(5,'PAY17935145243031B4571F7',9,'ORD17935145236219585',19,298.00,1,'MOCK1793514524350','mock-pay','2026-11-01 14:28:44','2026-11-01 14:28:44','2026-11-01 14:28:44',0),(6,'PAY179351475992994203FE4',10,'ORD17935147595341113',20,298.00,1,'MOCK1793514759959','mock-pay','2026-11-01 14:32:40','2026-11-01 14:32:40','2026-11-01 14:32:40',0),(7,'PAY1793514851614DA4A87F4',11,'ORD17935148509098833',21,298.00,1,'MOCK1793514851640','mock-pay','2026-11-01 14:34:12','2026-11-01 14:34:12','2026-11-01 14:34:12',0),(8,'PAY1793514980045903D6D6E',12,'ORD17935149793163346',22,298.00,1,'MOCK1793514980075','mock-pay','2026-11-01 14:36:20','2026-11-01 14:36:20','2026-11-01 14:36:20',0);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refund_application`
--

DROP TABLE IF EXISTS `refund_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refund_application` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `order_no` varchar(64) NOT NULL,
  `user_id` bigint NOT NULL,
  `refund_amount` decimal(10,2) NOT NULL,
  `reason` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `images` json DEFAULT NULL,
  `return_carrier` varchar(100) DEFAULT NULL,
  `return_tracking_no` varchar(100) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0 pending, 1 approved, 2 rejected, 3 refunded',
  `audit_remark` varchar(500) DEFAULT NULL,
  `auditor_id` bigint DEFAULT NULL,
  `audit_time` datetime DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_refund_application_user` (`user_id`,`create_time`),
  KEY `idx_refund_application_order` (`order_id`,`status`),
  KEY `idx_refund_application_status` (`status`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund_application`
--

LOCK TABLES `refund_application` WRITE;
/*!40000 ALTER TABLE `refund_application` DISABLE KEYS */;
INSERT INTO `refund_application` VALUES (1,7,'ORD17935112591385715',13,298.00,'QA 测试退款','模拟支付后验证退款申请',NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-11-01 13:34:20','2026-11-01 13:34:20',0),(2,9,'ORD17935145236219585',19,298.00,'E2E 自动化验收退款申请',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-11-01 14:28:49','2026-11-01 14:28:49',0),(3,10,'ORD17935147595341113',20,298.00,'E2E 自动化验收退款申请',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-11-01 14:32:41','2026-11-01 14:32:41',0),(4,11,'ORD17935148509098833',21,298.00,'E2E 自动化验收退款申请',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-11-01 14:34:13','2026-11-01 14:34:13',0),(5,12,'ORD17935149793163346',22,298.00,'E2E 自动化验收退款申请',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-11-01 14:36:21','2026-11-01 14:36:21',0);
/*!40000 ALTER TABLE `refund_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_cart`
--

DROP TABLE IF EXISTS `shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `album_id` bigint NOT NULL COMMENT '专辑ID',
  `album_name` varchar(200) NOT NULL COMMENT '专辑名称',
  `album_cover` varchar(500) DEFAULT NULL COMMENT '专辑封面',
  `price` decimal(10,2) NOT NULL COMMENT '单价',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '数量',
  `is_selected` tinyint(1) DEFAULT '1' COMMENT '是否选中 0-否 1-是',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_album_id` (`album_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_cart`
--

LOCK TABLES `shopping_cart` WRITE;
/*!40000 ALTER TABLE `shopping_cart` DISABLE KEYS */;
INSERT INTO `shopping_cart` VALUES (1,6,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,2,1,'2026-11-01 13:19:44','2026-11-01 13:19:46',1),(2,13,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,1,'2026-11-01 13:34:19','2026-11-01 13:34:20',1),(3,16,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,1,'2026-11-01 14:24:01','2026-11-01 14:24:01',0),(4,17,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,1,'2026-11-01 14:25:19','2026-11-01 14:25:19',0),(5,18,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,1,'2026-11-01 14:26:47','2026-11-01 14:26:47',0),(6,19,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,1,'2026-11-01 14:28:40','2026-11-01 14:28:40',0),(7,20,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,1,'2026-11-01 14:32:38','2026-11-01 14:32:38',0),(8,21,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,1,'2026-11-01 14:34:09','2026-11-01 14:34:09',0),(9,22,2,'限量珍藏版-追光者','https://example.com/cover2.jpg',298.00,1,1,'2026-11-01 14:36:16','2026-11-01 14:36:16',0);
/*!40000 ALTER TABLE `shopping_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '歌曲ID',
  `album_id` bigint NOT NULL COMMENT '所属专辑ID',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '歌曲名称',
  `artist` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '演唱者',
  `duration` int NOT NULL COMMENT '时长(秒)',
  `audio_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '完整音频文件URL',
  `preview_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '试听音频URL',
  `preview_duration` int NOT NULL DEFAULT '30' COMMENT '试听时长(秒)',
  `track_number` int NOT NULL COMMENT '曲目序号',
  `lyrics` text COLLATE utf8mb4_unicode_ci COMMENT '歌词',
  `play_count` int NOT NULL DEFAULT '0' COMMENT '播放次数',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_album_id` (`album_id`),
  KEY `idx_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='歌曲表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,1,'星际旅行','星辰乐队',245,'https://example.com/audio/song1.mp3','https://example.com/audio/song1_preview.mp3',30,1,NULL,1,0,'2026-10-15 10:59:01','2026-10-15 10:59:01'),(2,1,'夜色温柔','星辰乐队',198,'https://example.com/audio/song2.mp3','https://example.com/audio/song2_preview.mp3',30,2,NULL,0,0,'2026-10-15 10:59:01','2026-10-15 10:59:01'),(3,1,'未来已来','星辰乐队',223,'https://example.com/audio/song3.mp3','https://example.com/audio/song3_preview.mp3',30,3,NULL,0,0,'2026-10-15 10:59:01','2026-10-15 10:59:01'),(4,2,'追光','月影',267,'https://example.com/audio/song4.mp3','https://example.com/audio/song4_preview.mp3',30,1,NULL,2,0,'2026-10-15 10:59:02','2026-10-15 10:59:02'),(5,2,'晨曦','月影',201,'https://example.com/audio/song5.mp3','https://example.com/audio/song5_preview.mp3',30,2,NULL,1,0,'2026-10-15 10:59:02','2026-10-15 10:59:02');
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_log`
--

DROP TABLE IF EXISTS `stock_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `album_id` bigint NOT NULL COMMENT '专辑ID',
  `quantity` int NOT NULL COMMENT '数量（正数为扣减，负数为恢复）',
  `before_stock` int NOT NULL COMMENT '操作前库存',
  `after_stock` int NOT NULL COMMENT '操作后库存',
  `order_no` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联订单号',
  `type` tinyint NOT NULL COMMENT '类型：1-下单扣减，2-取消恢复，3-超时恢复',
  `remark` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_album_id` (`album_id`),
  KEY `idx_order_no` (`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存流水表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_log`
--

LOCK TABLES `stock_log` WRITE;
/*!40000 ALTER TABLE `stock_log` DISABLE KEYS */;
INSERT INTO `stock_log` VALUES (1,1,1,1000,999,'ORD17920368989504778',1,'用户下单扣减库存','2026-10-15 12:01:38'),(2,1,-1,999,1000,'ORD17920368989504778',2,'用户取消订单恢复库存','2026-10-15 12:17:00'),(3,1,1,1000,999,'ORD17920393271626932',1,'用户下单扣减库存','2026-10-15 12:42:07'),(4,1,-1,999,1000,'ORD20261015124229573',2,'用户取消订单恢复库存','2026-10-15 12:44:00'),(5,1,-1,1000,1001,'ORD17920393271626932',2,'用户取消订单恢复库存','2026-10-15 12:58:00'),(6,2,2,500,498,'ORD1793510384343394',1,'用户下单扣减库存','2026-11-01 13:19:45'),(7,2,1,498,497,'ORD17935106110857310',1,'用户下单扣减库存','2026-11-01 13:23:31'),(8,2,1,497,498,'ORD17935106110857310',2,'订单取消或超时后恢复库存','2026-11-01 13:23:31'),(9,2,1,498,497,'ORD17935112591385715',1,'用户下单扣减库存','2026-11-01 13:34:19'),(10,2,2,497,499,'ORD1793510384343394',2,'订单取消或超时后恢复库存','2026-11-01 13:35:00'),(11,2,1,499,498,'ORD17935145236219585',1,'用户下单扣减库存','2026-11-01 14:28:43'),(12,2,1,498,497,'ORD17935147595341113',1,'用户下单扣减库存','2026-11-01 14:32:39'),(13,2,1,497,496,'ORD17935148509098833',1,'用户下单扣减库存','2026-11-01 14:34:10'),(14,2,1,496,495,'ORD17935149793163346',1,'用户下单扣减库存','2026-11-01 14:36:19');
/*!40000 ALTER TABLE `stock_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '昵称',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-正常',
  `role` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user' COMMENT '角色：admin-管理员，user-普通用户',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_phone` (`phone`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'testuser','0c9023f5706d3d5defee107ba6c12d99','测试用户','13800138000','test@example.com',NULL,1,'user',0,'2026-10-15 10:05:57','2026-10-15 10:05:57'),(2,'boboa','d07ab387b2ffeebbec4131e6b175351e','bobo','15524537619','2645123351@qq.com',NULL,1,'user',0,'2026-10-20 22:12:35','2026-10-20 22:12:35'),(3,'1234','0c9023f5706d3d5defee107ba6c12d99','1234',NULL,NULL,NULL,1,'user',0,'2026-11-01 02:49:25','2026-11-01 02:49:25'),(4,'music_test_2026','50fb070f04558483df2ea4797df41bea','接口测试用户',NULL,'music_test_2026@example.com',NULL,1,'user',0,'2026-11-01 12:26:06','2026-11-01 12:26:06'),(5,'qa91857106','76e7eaef9e384fbd1886f46bcbada9e9','QA临时测试',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:19:12','2026-11-01 13:19:12'),(6,'qaflow54125926','b4755f551f3f47c05ec927f00c86068f','流程测试',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:19:43','2026-11-01 13:19:43'),(7,'qatest1101132259664','f41c54bc519ebfc9dfc05b44a17f75ff','QA Isolation',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:23:00','2026-11-01 13:23:00'),(8,'qat1101132315','d5171782eb79c3d5709ffc030d1fcccb','QA',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:23:16','2026-11-01 13:23:16'),(9,'qao1101132330','d5171782eb79c3d5709ffc030d1fcccb','QA owner',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:23:31','2026-11-01 13:23:31'),(10,'qab1101132330','d5171782eb79c3d5709ffc030d1fcccb','QA other',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:23:31','2026-11-01 13:23:31'),(11,'qap1101132406','ae16f9c6e5dab81851f9760d3c3d1e3e','QA资料测试',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:24:06','2026-11-01 13:24:06'),(12,'qadm1101132536','d5171782eb79c3d5709ffc030d1fcccb','qadm1101132536',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:25:37','2026-11-01 13:25:37'),(13,'qaflow1101133417','d5171782eb79c3d5709ffc030d1fcccb','QA End-to-End',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:34:18','2026-11-01 13:34:18'),(14,'qabb1101133436','d5171782eb79c3d5709ffc030d1fcccb','QA Blindbox',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:34:37','2026-11-01 13:34:37'),(15,'qastk1101133538','d5171782eb79c3d5709ffc030d1fcccb','QA stock',NULL,NULL,NULL,1,'user',0,'2026-11-01 13:35:39','2026-11-01 13:35:39'),(16,'e2eqa3514237197','df25428124ddd136bc7e41fd6f620b74','e2eqa3514237197',NULL,NULL,NULL,1,'user',0,'2026-11-01 14:23:59','2026-11-01 14:23:59'),(17,'e2eqa3514316301','df25428124ddd136bc7e41fd6f620b74','e2eqa3514316301',NULL,NULL,NULL,1,'user',0,'2026-11-01 14:25:18','2026-11-01 14:25:18'),(18,'e2eqa3514405015','df25428124ddd136bc7e41fd6f620b74','e2eqa3514405015',NULL,NULL,NULL,1,'user',0,'2026-11-01 14:26:46','2026-11-01 14:26:46'),(19,'e2eqa3514516010','df25428124ddd136bc7e41fd6f620b74','e2eqa3514516010',NULL,NULL,NULL,1,'user',0,'2026-11-01 14:28:40','2026-11-01 14:28:40'),(20,'e2eqa3514754173','df25428124ddd136bc7e41fd6f620b74','e2eqa3514754173',NULL,NULL,NULL,1,'user',0,'2026-11-01 14:32:37','2026-11-01 14:32:37'),(21,'e2eqa3514843002','df25428124ddd136bc7e41fd6f620b74','e2eqa3514843002',NULL,NULL,NULL,1,'user',0,'2026-11-01 14:34:07','2026-11-01 14:34:07'),(22,'e2eqa3514974025','df25428124ddd136bc7e41fd6f620b74','e2eqa3514974025',NULL,NULL,NULL,1,'user',0,'2026-11-01 14:36:16','2026-11-01 14:36:16');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_address` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `receiver_name` varchar(20) NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(11) NOT NULL COMMENT '联系电话',
  `province` varchar(50) NOT NULL COMMENT '省份',
  `city` varchar(50) NOT NULL COMMENT '城市',
  `district` varchar(50) NOT NULL COMMENT '区县',
  `detail_address` varchar(200) NOT NULL COMMENT '详细地址',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认 0-否 1-是',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_default` (`is_default`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户收货地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address`
--

LOCK TABLES `user_address` WRITE;
/*!40000 ALTER TABLE `user_address` DISABLE KEYS */;
INSERT INTO `user_address` VALUES (1,6,'测试收件人甲','13800138001','北京市','北京市','海淀区','测试路2号',1,'2026-11-01 13:19:43','2026-11-01 13:19:43',0),(2,6,'测试收件人乙','13800138002','北京市','北京市','朝阳区','测试街道3号',1,'2026-11-01 13:19:43','2026-11-01 13:19:44',1),(3,9,'测试用户','13800001234','浙江省','杭州市','西湖区','测试路一号',1,'2026-11-01 13:23:31','2026-11-01 13:23:31',1),(4,13,'流程测试','13800001234','浙江省','杭州市','西湖区','测试路二号',1,'2026-11-01 13:34:19','2026-11-01 13:34:19',0),(5,14,'盲盒测试','13800001234','浙江省','杭州市','西湖区','测试路三号',1,'2026-11-01 13:34:37','2026-11-01 13:34:37',0),(6,15,'库存测试','13800001234','浙江省','杭州市','西湖区','测试路四号',1,'2026-11-01 13:35:40','2026-11-01 13:35:40',1),(7,18,'E2E 测试用户','13800001234','浙江省','杭州市','西湖区','自动化测试路 1 号',1,'2026-11-01 14:26:48','2026-11-01 14:26:48',0),(8,19,'E2E 测试用户','13800001234','浙江省','杭州市','西湖区','自动化测试路 1 号',1,'2026-11-01 14:28:42','2026-11-01 14:28:42',0),(9,20,'E2E 测试用户','13800001234','浙江省','杭州市','西湖区','自动化测试路 1 号',1,'2026-11-01 14:32:39','2026-11-01 14:32:39',0),(10,21,'E2E 测试用户','13800001234','浙江省','杭州市','西湖区','自动化测试路 1 号',1,'2026-11-01 14:34:10','2026-11-01 14:34:10',0),(11,22,'E2E 测试用户','13800001234','浙江省','杭州市','西湖区','自动化测试路 1 号',1,'2026-11-01 14:36:19','2026-11-01 14:36:19',0);
/*!40000 ALTER TABLE `user_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_draw_stat`
--

DROP TABLE IF EXISTS `user_draw_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_draw_stat` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `box_id` bigint NOT NULL,
  `total_count` int NOT NULL DEFAULT '0' COMMENT '总抽数',
  `sr_count` int NOT NULL DEFAULT '0' COMMENT '距离上次SR的抽数',
  `ssr_count` int NOT NULL DEFAULT '0' COMMENT '距离上次SSR的抽数',
  `last_draw_time` datetime DEFAULT NULL COMMENT '最后抽奖时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_box` (`user_id`,`box_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户抽奖统计表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_draw_stat`
--

LOCK TABLES `user_draw_stat` WRITE;
/*!40000 ALTER TABLE `user_draw_stat` DISABLE KEYS */;
INSERT INTO `user_draw_stat` VALUES (1,14,1,1,1,1,'2026-11-01 13:34:37','2026-11-01 13:34:37','2026-11-01 13:34:37');
/*!40000 ALTER TABLE `user_draw_stat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'music_system'
--

--
-- Dumping routines for database 'music_system'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-01 14:37:48
