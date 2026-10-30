-- 从 music_fetch 库（网易云爬虫项目）迁移专辑和歌曲数据到 music_system
-- 执行日期：2026-10-23  执行前已用 mysqldump 做全库备份 backup_music_system_20261023.sql
-- 范围：仅 type='专辑' 的 433 张专辑及其下 496 首歌；演示数据（专辑1-3及关联）已先删除
-- 约定：保留网易云原始ID作主键；价格统一280元、库存100、上架；商品形态 PHYSICAL；
--       32 首有本地音频的歌 audio_url 指向 /media/audio/{id}.mp3（文件已复制到 ~/music-system-uploads/audio）

USE music_system;

-- ========== 1. 清除演示数据 ==========
DELETE FROM stock_log;
DELETE FROM payment;
DELETE FROM order_info;
DELETE FROM shopping_cart;
DELETE FROM blind_box_prize;
DELETE FROM blind_box;
DELETE FROM draw_record;
DELETE FROM user_draw_stat;
DELETE FROM song;
DELETE FROM album;

-- ========== 2. 迁移专辑（433 张，type='专辑'） ==========
-- publish_time 为毫秒时间戳；0/NULL 的用当前日期兜底（release_date NOT NULL）
INSERT INTO album (id, title, artist, cover_url, description, release_date,
                   price, stock, sales, status, is_limited, deleted, product_type)
SELECT a.id,
       a.name,
       COALESCE(ar.name, '未知歌手'),
       a.pic_url,
       a.description,
       COALESCE(NULLIF(CAST(FROM_UNIXTIME(a.publish_time / 1000) AS DATE), '1970-01-01'), CURDATE()),
       280.00,
       100,
       0,
       1,
       0,
       0,
       'PHYSICAL'
FROM music_fetch.album a
LEFT JOIN music_fetch.artist ar ON ar.id = a.artist_id
WHERE a.type = '专辑';

-- ========== 3. 迁移歌曲（上述专辑下的全部歌曲） ==========
-- duration 毫秒转秒；track_number 按专辑内歌曲ID顺序生成；歌词取 LRC 原文；
-- artist 用所属专辑的主歌手；audio_url 仅 32 首已下载的歌填写（/media 静态映射）
INSERT INTO song (id, album_id, title, artist, duration, audio_url,
                  preview_url, preview_duration, track_number, lyrics, play_count, deleted)
SELECT s.id,
       s.album_id,
       s.name,
       COALESCE(ar.name, '未知歌手'),
       ROUND(s.duration / 1000),
       CASE WHEN s.download_status = 1 AND s.file_path IS NOT NULL
            THEN CONCAT('/media/audio/', s.id, '.mp3') END,
       NULL,
       30,
       ROW_NUMBER() OVER (PARTITION BY s.album_id ORDER BY s.id),
       ly.lrc,
       s.play_count,
       0
FROM music_fetch.song s
JOIN music_fetch.album fa ON fa.id = s.album_id AND fa.type = '专辑'
LEFT JOIN music_fetch.artist ar ON ar.id = fa.artist_id
LEFT JOIN music_fetch.lyric ly ON ly.song_id = s.id;
