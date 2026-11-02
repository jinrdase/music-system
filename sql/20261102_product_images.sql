-- Product image completion migration for the local MySQL 8.0 database.
-- Run once after reviewing backup/product_image_fields_before_20261102.json.
-- Only image fields and the additive blind_box.cover_url column are changed.

ALTER TABLE blind_box
    ADD COLUMN cover_url varchar(1000) NULL COMMENT '盲盒商品封面图片地址' AFTER name;

UPDATE album SET cover_url = CASE id
    WHEN 1 THEN '/media/image/album-01-night-voyage.jpg'
    WHEN 2 THEN '/media/image/album-02-chasing-light.jpg'
    WHEN 3 THEN '/media/image/album-03-city-echoes.jpg'
    WHEN 4 THEN '/media/image/album-04-qa-jazz-vinyl.jpg'
    WHEN 5 THEN '/media/image/album-05-qa-rock-stage.jpg'
    WHEN 6 THEN '/media/image/album-06-qa-neon-gradient.jpg'
    WHEN 7 THEN '/media/image/album-07-qa-classical-piano.jpg'
    WHEN 8 THEN '/media/image/album-08-qa-red-vinyl.jpg'
    WHEN 9 THEN '/media/image/album-09-qa-rock-lights.jpg'
    WHEN 10 THEN '/media/image/album-10-qa-geometric-electronic.jpg'
    WHEN 11 THEN '/media/image/album-11-qa-vinyl-classic.jpg'
    WHEN 12 THEN '/media/image/album-12-qa-guitar-energy.jpg'
    WHEN 13 THEN '/media/image/album-13-qa-galaxy-forest.jpg'
    WHEN 14 THEN '/media/image/album-14-qa-neon-art.jpg'
    ELSE cover_url
END
WHERE id BETWEEN 1 AND 14;

UPDATE blind_box SET cover_url = CASE id
    WHEN 1 THEN '/media/image/blindbox-01-classic-figurine.jpg'
    WHEN 2 THEN '/media/image/blindbox-02-qa-garden-figure.jpg'
    WHEN 3 THEN '/media/image/blindbox-03-qa-heart-teddy.jpg'
    WHEN 4 THEN '/media/image/blindbox-04-qa-pink-gift-bear.jpg'
    WHEN 5 THEN '/media/image/blindbox-05-qa-figurine-shelf.jpg'
    WHEN 6 THEN '/media/image/blindbox-06-qa-art-figurine.jpg'
    ELSE cover_url
END
WHERE id BETWEEN 1 AND 6;

UPDATE blind_box_prize SET image_url = CASE box_id
    WHEN 1 THEN '/media/image/blindbox-01-classic-figurine.jpg'
    WHEN 2 THEN '/media/image/blindbox-02-qa-garden-figure.jpg'
    WHEN 3 THEN '/media/image/blindbox-03-qa-heart-teddy.jpg'
    WHEN 4 THEN '/media/image/blindbox-04-qa-pink-gift-bear.jpg'
    WHEN 5 THEN '/media/image/blindbox-05-qa-figurine-shelf.jpg'
    WHEN 6 THEN '/media/image/blindbox-06-qa-art-figurine.jpg'
    ELSE image_url
END
WHERE id BETWEEN 1 AND 22;
