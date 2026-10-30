/*
 Navicat Premium Data Transfer

 Source Server         : spring_boot
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3308
 Source Schema         : music_system

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 30/10/2026 15:31:58
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
  `product_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PHYSICAL' COMMENT 'PHYSICAL or DIGITAL',
  `digital_content_url` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Private digital delivery target',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_artist`(`artist` ASC) USING BTREE,
  INDEX `idx_release_date`(`release_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 385010223 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专辑表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of album
-- ----------------------------
INSERT INTO `album` VALUES (172195, 'The Ultimate Collection', 'Michael Jackson', 'https://p3.music.126.net/4fK_UU_c6IHbq7wrAW4Qow==/18715886929967779.jpg', 'The Ultimate Collection is a box set by American recording artist Michael Jackson. It was released on November 16, 2004 by Epic Records and consist of four audio CDs and one DVD. The album sold 57,000 copies in 2004 only, and on May 16, 2013, it was certified Gold as a multi-disk package by Recording Industry Association of America (RIAA) for physical shipments of 100,000 copies; its certification was then upgraded to Platinum, signifying shipments of 200,000 copies, in the same date. the DVD marked the first appearance of Live in Bucharest: The Dangerous Tour, which was later released as an individual title on July 25, 2005.', '2004-09-16', 280.00, 100, 0, 1, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (172259, 'HIStory: Past, Present and Future, Book I', 'Michael Jackson', 'https://p4.music.126.net/GtZLLolNwCn07Ke-HZxX1Q==/109951165994661423.jpg', '★两度入列摇滚名人殿堂 流行界唯一天王之冠军精选，1995年第九张录音室专辑\n★收录与妹妹Janet Jackson合唱之” Scream”, 麦可最具争议性作品之一的” They Don`t Care About Us”, 展现关怀地球大爱单曲” Earth Song”等杰作\n\n13座葛莱美奖以及「葛莱美传奇奖」和「葛莱美终身成就奖」，所有艺人之最26个全美音乐奖，其中包括「世纪艺术家」和「20世纪80年代艺术家」；个人拥有13首美国冠军单曲，名列billboard最多百大单曲男歌手；多项金氏世界纪录，超过4亿的全球销量记录，数百个奖项，使他成为流行音乐历史上获奖最多的艺人。两度入选摇滚名人堂，也有被选入作曲者名人堂，并且是唯一一位进入舞蹈名人堂的流行艺人。创造独一无二的炫目舞步，从殭尸舞、月球漫步、机械舞，到45度角倾斜的高难度舞步，引领视觉感官新震撼、全球争相模仿其穿著打扮。Michael Jackson麦可杰克森永远无可取代的流行界唯一天王。扎根于节奏蓝调乐，不分派系风格与种族藩篱向外延伸，开发流行音乐的无限可能性！纵然2009年6月25日Michael的骤逝令人伤感不已，但他对音乐、舞蹈和时尚的贡献，无论多少风雨之后，Michael Jackson这个名字仍然是在这个时代中全球流行文化的代表人物。\nHIStory: Past, Present and Future, Book I (usually shortened to HIStory) is the ninth studio album by American recording artist Michael Jackson. It was released on July 16, 1995 by Epic Records. This is Jackson\'s first album on his own label, MJJ Productions. The majority of the album\'s tracks were written and produced by Jackson.\nHIStory was the first album to be released by Jackson since he was accused of child sexual abuse in August 1993. Recorded during late 1994 and early 1995, several of the double album\'s 15 songs pertain to the accusations and Jackson\'s mistreatment in the media, specifically the tabloids. The songs\' themes included environmental awareness, isolation, greed, and injustice.\nHIStory is Jackson\'s most controversial album. Jackson was accused of using anti-Semitic lyrics in \"They Don\'t Care About Us\". Jackson stated that he did not mean any offense and on multiple occasions denied anti-Semitism. The dispute regarding the lyrics ended with Jackson re-recording them.\nR.Kelly was accused of plagiarizing one of the album\'s songs, \"You Are Not Alone\". In 2007 a judge ruled that the song was plagiarized and the song was subsequently banned from radio stations in Belgium.\n\nMichael Jackson\'s double-disc HIStory: Past, Present, and Future, Book I is a monumental achievement of ego. Titled \"HIStory Begins,\" the first disc is a collection of his post-Motown hits, featuring some of the greatest music in pop history, including \"Billie Jean,\" \"Don\'t Stop \'Til You Get Enough,\" \"Beat It,\" and \"Rock with You.\"\nIt leaves some hits out -- including the number ones \"Say Say Say\" and \"Dirty Diana\" -- yet it\'s filled with enough prime material to be thoroughly intoxicating.\nThat can\'t be said for the second disc, called \"HIStory Continues\" and consisting entirely of new material -- which also happens to be the first material he released since being accused of child molestation.\n\"HIStory Continues\" is easily the most personal album Jackson has recorded. References to the scandal permeate almost every song, creating a thick atmosphere of paranoia. If Jackson\'s music had been the equal of Thriller or Bad, the nervous, vindictive lyrics wouldn\'t have been quite as overbearing. However, \"HIStory Continues\" reiterates musical ideas Jackson had been exploring since Bad.\nJackson certainly tries to stay contemporary, yet he has a tendency to smooth out all of his rougher musical edges with show-biz schmaltz.\nOccasionally, Jackson produces some well-crafted pop that ranks with his best material: R. Kelly\'s \"You Are Not Alone\" is seductive, \"Scream\" improves on the slamming beats of his earlier single \"Jam,\" and \"Stranger in Moscow\" is one of his most haunting ballads.\nNevertheless, \"HIStory Continues\" stands as his weakest album since the mid-\'70s.\n', '1995-06-20', 280.00, 100, 0, 1, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (1958174, 'Michael', 'Michael Jackson', 'https://p3.music.126.net/SKSqPqfIZHppDfB4sD9VSA==/109951168546226329.jpg', '传奇 尚未结束…\n请与十亿歌迷一同怀念\n\n◎搜藏无可取代的流行乐之王Michael Jackson2007-2009来不及发表之尚未曝光七首全新创作\n\n◎首支单曲\"Hold My Hand\"由Michael Jackson与嘻哈歌手Akon真情合唱，引爆YouTube超过320万收听狂潮\n\n◎特邀格莱美奖最佳摇滚歌手Lenny Kravitz共襄盛举\n\n\n在这个世界上，流行之王只有一位，那就是Michael Jackson。他的音乐领导流行，他的舞技独步全球，他的音乐录影带开创新视野，他的时尚穿着永远独领风骚，他的举手投足抢尽了所有的风采，他的骤然过世令人错愕。2010年12月14号发行的最新大碟《MICHAEL》将再度证明他在流行乐坛无可取代的价值！\n\nMichael Jackson时时刻刻都在为下一张专辑进行歌曲创作与音乐制作，无论他是在新泽西拜访好友，或是自己找一群音乐高手一起踏进拉斯维加斯与洛杉矶的录音室，Michael Jackson的创作灵感总是源源不绝。在索尼音乐旗下所属的EPIC唱片公司与Michael Jackson遗产管理委员会统筹制作之下，将Michael Jackson在过世前已经完成，但却来不及发表的精采歌曲制作成众所瞩目的年度大碟《MICHAEL》，全球乐迷将可以从这些才华洋溢的音乐作品之中，听见流行之王的内心世界。\n\n年度大碟《MICHAEL》搜藏了Michael Jackson在2007年到2009年过世前这段期间的歌曲，从流行抒情，动感舞曲，节奏蓝调，灵魂乐，饶舌嘻哈到黑人时尚摇摆乐，曲风多元，应有尽有。专辑中的首支单曲\"Hold My Hand\"是Michael与节奏蓝调/嘻哈全才歌手Akon在2007年携手合作的至情之歌，美国MTV音乐频道盛赞：「这是Michael Jackson的经典情歌，呼吁世人和谐相处的感人之作。」曾经掌舵制作Michael Jackson1991年专辑《Dangerous》的当代节奏蓝调与嘻哈界制作大将Teddy Riley负责了等多首歌曲的制作，包括闪动黑人摇摆舞曲节奏动感风采的街头派对劲作\"Hollywood Tonight\"。Michael在与格莱美奖最佳摇滚男歌手得主Lenny Kravitz联手合作的感伤作品\"(I Can\'t Make It) Another Day\"中重现了出神入化的假音演唱技巧。\n\nMichael Jackson的全球唱片销售估计超过七亿五千万张，生涯创造十三首全美热门单曲榜冠军曲，两度入列美国摇滚名人殿堂，吉尼斯世界纪录认证肯定Michael Jackson是史上最成功的娱乐界艺人，他的《Thriller》专辑以七千万张的销售数字认证为史上最畅销的专辑，来自《Thriller》这张专辑的\"Billie Jean\"、\"Beat It\"等7首单曲的全球累积销售超过一亿张。Michael Jackson生平荣获十三座格莱美奖，同时获得全美音乐奖颁发世纪艺人奖。\n\n《MICHAEL》的专辑封面来自于荣获艺术奖肯定的非裔美籍的插画艺术家Kadir Nelson在2009年为Michael所绘制的油画作品，卡迪尔在这幅油画作品中流露出他经由艺术创作述说画作中的人物故事的功力，体现了Michael Jackson一生中最关键的时刻与不同时期的造型。\n\n举世瞩目的Michael Jackson全新录音室专辑《MICHAEL》将会于12月14日由索尼音乐联合Michael Jackson的遗产管理委员会共同推出。\n\n流行音乐之王Michael Jackson从未停止过创作，也许很多歌迷并不知道，Michael与他的音乐团队在过去的几年里一直在筹备他的这张新专辑，无论是在新泽西的友人家中，还是在拉斯韦加斯和洛杉矶的录音棚，都留下了他们的创作足迹。现在全世界的乐迷们将通过聆听这张全新的专辑《MICHAEL》以及歌曲背后的故事，来走近天王的内心，了解他在人生的最后几年极力想要展现的音乐世界。\n', '2010-12-14', 280.00, 100, 0, 1, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (2622323, 'The Ultimate Fan Extras Collection', 'Michael Jackson', 'https://p3.music.126.net/nGFJF1DBUNUSvGHLkub8YQ==/2535473814012575.jpg', NULL, '2013-07-24', 280.00, 100, 0, 1, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (2627713, 'The Indispensable Collection', 'Michael Jackson', 'https://p3.music.126.net/YiIY6Dm8PgrvTASFNKha5Q==/6661940953389993.jpg', NULL, '2013-06-21', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (2805307, 'XSCAPE', 'Michael Jackson', 'https://p3.music.126.net/4b4SwvxIabWK0sWi7OSX-g==/109951169267463715.jpg', '◎由EPIC唱片总裁L.A. Reid与麦可杰克森遗产管理委员会精挑麦可1983-1999年灌录八首从未发表超强作品\n◎邀请贾斯汀、杰斯、碧昂丝、布兰妮、克里斯小子等天王製作群赋予现代潮流极限节奏\n◎收录SONY XPERIA Z2手机全球广告曲〈Slave To The Rhythm〉\n◎豪华版加收八首原始录音、与贾斯汀对唱版〈Love Never Felt So Good〉共17首作品\n\n\n永远无可取代的流行界唯一天王麦可杰克森，创造独一无二的炫目舞步，从殭尸舞、月球漫步、机械舞，到45度角倾斜的高难度舞步，引领视觉感官新震撼、全球争相模仿其穿著打扮。扎根于节奏蓝调乐，不分派系风格与种族藩篱向外延伸，开发流行音乐的无限可能性！2009年6月25日麦可的骤逝令人伤感不已，将过世前已完成却来不及发表的大碟《Michael》隔年问市，创下短短一週内世界各地狂销超过300万张，成为2010年全球最畅销专辑之一。相距3年后，由EPIC唱片总裁L.A. Reid担任监製，和「麦可杰克森资产管理委员会」将过去40年音乐资产，挑选已完成录音的8首全新作品汇整，推出众所瞩目专辑《Xscape超脱》。邀请金牌製作团队：跨界音乐魔术师Timbaland(贾斯汀)、4座葛莱美肯定Rodney Jerkins(布兰妮)、2006和2008年居冠告示牌「年度製作人」Stargate(碧昂丝)、3座葛莱美加身J-Roc(克里斯小子)、麦可多张专辑操手John McClain(珍娜杰克森)赋予单曲现代全新潮流节奏。\n\n麦可和传奇情歌圣手Paul Anka，替赢得葛莱美终身成就奖的Johnny Mathis量身打造〈Love Never Felt So Good〉，拿回重新诠释下的版本，回归70年代Funky Soul律动，建构在麦可自Motown唱片走红的基础音场裡头，加上弦乐的温柔辅佐，重现传统黑人音乐的荣景；铺满顺畅R&B旋律的〈Chicago〉，麦可以两段不同情绪交叠演绎，特别引人入胜；虽然〈Loving You〉是支抒情小品，却透著强烈节拍与复古灵韵混搭，招牌和声依然打动每个人的芳心；电气响音迴盪80年代氛围的〈A Place With No Name〉，精彩改编民摇/乡村摇滚乐团America的〈A Place With No Name〉；弦乐拉启〈Slave To The Rhythm〉序幕，随后释放狂放旋律，同时还过瘾的摇摆出异国情调，选为SONY XPERIA Z2手机广告曲全球播送；碰撞Synthpop能量的〈Do You Know Where Your Children Are〉，另一方面又解构现代流行和R&B迷人频率；同名曲〈Xscape〉，有90年代最受欢迎的R&B调性，也有《Dangerous》时期的些许影子，加入怦然心动的古典弦乐搭衬，是支完美的谢幕曲！此张豪华影音盘，加赠8首歌原始录音，还特别加收深受麦可影响的最潮型男Justin Timberlake时空对唱〈Love Never Felt So Good〉。麦可，他并没有离开我们，只是上演一齣世纪超级脱逃秀，从眼前华丽消逝，留下迴盪耳际动人佳音一听再听！\n《XSCAPE》将由EPIC RECORDS主席L.A. Reid担任执行制作，Timbaland担任首席制作人。制作人在保留迈克尔·杰克逊最本质的声音和最完整的音乐性的前提下，加入了一些符合当下流行的音乐元素。整个过程，用Reid的话来形容就是“同一化”。新专辑的命名，也沿用了迈克尔·杰克逊以往专辑的做法。用一首歌曲名来命名该张专辑，而且名字往往是一个单词，短小精悍且不失前卫性，这种做法从《Thriller》就开始。而“XSCAPE”正是新专辑中收录一首歌曲，值得一提的是，该首歌曲当时是由迈克尔·杰克逊和Rodney Jerkins一同录制完成，而Jerkins也一起参与了新专辑的制作，这也再次体现了新专辑“同一化”的概念。', '2014-05-12', 280.00, 100, 0, 1, 0, 0, '2026-10-23 10:16:46', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (2835047, 'Love Never Felt So Good (Fedde Le Grand Remix Radio Edit)', 'Michael Jackson', 'https://p4.music.126.net/KBR32zfo7iGMwB9RBfZY7w==/109951167271334643.jpg', NULL, '2014-05-20', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (2894086, 'Love Never Felt So Good', 'Michael Jackson', 'https://p4.music.126.net/MUsc2kLd3jr4QkvwGgxEcg==/5885685743770627.jpg', NULL, '2014-05-19', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (2915337, 'Slave To The Rhythm (Audien Remix)', 'Michael Jackson', 'https://p4.music.126.net/MFG-WBMb15E-KY3vEVW0mw==/5916472069535863.jpg', NULL, '2014-07-28', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (3042654, 'PYT (Reflex Revision) / Get Kon the Floor', 'Michael Jackson', 'https://p3.music.126.net/3NSyKgMiYbAjden7JslfXw==/6665239488564679.jpg', NULL, '2014-06-23', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (34522208, 'Thriller 25 Super Deluxe Edition', 'Michael Jackson', 'https://p3.music.126.net/XoGSYxXkxqmOuzHYTcKuwg==/109951167124671592.jpg', NULL, '2013-03-12', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (36128338, 'Blood on the Dance Floor X Dangerous (The White Panda Mash-Up)', 'Michael Jackson', 'https://p3.music.126.net/An0GqiNgpV3fx3Vm7RPSfQ==/18425615858530023.jpg', '天王迈克尔·杰克逊混音新单《Blood on the Dance Floor X Dangerous(The White Panda Mash-Up)》发布，这也是9月29日即将发行的新专辑《Scream》里首支先行单曲。', '2017-09-06', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (36320406, 'Thriller (Steve Aoki Midnight Hour Remix)', 'Michael Jackson', 'https://p3.music.126.net/NN_s8b3Sl1Q2ebNFhtSdWw==/109951165983431073.jpg', '潮爷Steve Aoki混音MJ经典之作《Thriller》发布！', '2017-09-29', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (36412398, 'Scream', 'Michael Jackson', 'https://p3.music.126.net/OCz9NSbDK8ttIJkKOjm7vQ==/109951165982480921.jpg', '★两度入列摇滚名人殿堂 流行界唯一天王 首张舞曲概念精选专辑\n★收录破纪录超级冠军Dirty Diana．史上最畅销专辑同名金曲Thriller． Janet Jackson共同合作Scream及Torture． This Place Hotel． Somebody’s Watching Me等13首劲舞佳作\n★特别收录 ：“活体混搭音乐机器” DJ 双人组 The White Panda制作全新单曲Blood on the Dance Floor X Dangerous\n\n13座格莱美奖以及「格莱美传奇奖」和「格莱美终身成就奖」，所有艺人之最26个全美音乐奖，其中包括「世纪艺术家」和「20世纪80年代艺术家」；个人拥有13首美国冠军单曲，名列billboard最多百大单曲男歌手；多项金氏世界纪录，超过4亿的全球销量记录，数百个奖项，使他成为流行音乐历史上获奖最多的艺人。两度入选摇滚名人堂，也有被选入作曲者名人堂，并且是唯一一位进入舞蹈名人堂的流行艺人。创造独一无二的炫目舞步，从僵尸舞、月球漫步、机械舞，到45度角倾斜的高难度舞步，引领视觉感官新震撼、全球争相模仿其穿着打扮。 Michael Jackson麦可杰克森永远无可取代的流行界唯一天王。扎根于节奏蓝调乐，不分派系风格与种族藩篱向外延伸，开发流行音乐的无限可能性！纵然2009年6月25日Michael的骤逝令人伤感不已，但他对音乐、舞蹈和时尚的贡献，无论多少风雨之后，Michael Jackson这个名字仍然是在这个时代中全球流行文化的代表人物。\n\n这张由Sony Epic/Legacy Recordings与「麦可杰克森资产管理委员会」共同企划，以舞曲为题的概念专辑Scream中，精选流行乐之王40年演艺生涯中最俱电力与动感的13首精华作品。揉合了Michael明暗高低的各种面，每首歌曲各俱代表又主题明确。其中包括了选自Bad专辑中创下单一专辑连续5首No.1纪录的单曲Dirty Diana、名列金氏世界纪录「历年最畅销专辑」专辑同名单曲Thriller、与天后妹妹Janet Jackson合作的Scream ；同时原收录于The Jacksons专辑中，歌迷津津乐道的Torture、 由Michael首挑大梁包办词曲及编曲单曲作品This Place Hotel (原名Heartbreak Hotel)，以及首度出现在Michael专辑中1985年与哥哥Jermaine共同跨刀为Rockwell献声演唱的畅销单曲Somebody Watching Me…。\n\n另外专辑还收录了由拥有“活体混搭音乐机器” 称号的Mashup DJ双人组合The White Panda制作，解构Blood on the Dance Floor、Dangerous、This Place Hotel、Leave Me Alone及Is It Scary等五首单曲重组的全新单曲Blood on the Dance Floor X Dangerous，这首在专辑发行前发表，让所有歌迷似曾相识却又惊又喜的”新曲” 。\n他的舞步，舞台上的举手投足，不论历经多少时间，至今仍是许多人模仿学习的蓝本。就让我们在华丽精细的舞步中，一窥「King Of Pop」流行乐之王的舞曲精​​粹。', '2017-09-27', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (38978512, 'The Very Best of Michael Jackson Live to Air', 'Michael Jackson', 'https://p3.music.126.net/ZobrG8hc7S-jteXukVohOg==/109951163301526633.jpg', NULL, '2016-05-01', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (72148773, 'Love Never Felt So Good', 'Michael Jackson', 'https://p3.music.126.net/2CslJeRrWfU2ZyOT_rfGGA==/109951165969544714.jpg', NULL, '2014-05-02', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (72148791, 'XSCAPE', 'Michael Jackson', 'https://p3.music.126.net/ipLkFpnj68dnH-cgJ-3tgg==/109951165969538700.jpg', NULL, '2014-05-12', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (72148828, 'Love Never Felt So Good', 'Michael Jackson', 'https://p4.music.126.net/oxeRxaPRGNjEKJ8WRSkoOQ==/109951165969543790.jpg', NULL, '2014-05-02', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (72701829, 'Michael Jackson x Mark Ronson: Diamonds are Invincible', 'Michael Jackson', 'https://p4.music.126.net/fgxFtucsRu1a7zL_qVWpWw==/109951165984846578.jpg', '为庆祝Michael Jackson钻石生日庆典，新单由Mark Ronson制作并包含Michael Jackson最为经典的歌曲片段。', '2018-08-29', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (85476150, 'Changes', 'Justin Bieber', 'https://p4.music.126.net/arL022NQ94WEv97FzlwTgA==/109951164707732979.jpg', '★史上最多数位冠军单曲歌手、全球累积专辑销售超越6000万张\n★睽违五年第五张大碟滚石杂志、富比士册封为「2020最期待专辑」\n★*收录破亿点听冠军神曲“Yummy”、串流霸主巨星马龙、饶舌巨星Quavo等歌手倾力帮腔\n\n每个年代都会有一个足以撼动全球、影响世界的超级巨星，成为当下的流行信仰崇拜，并且传承音乐历史的火炬，从Michael Jackson、Prince、David Bowie、Madonna、Lady Gaga等人一脉相传，到了2007年，Justin Bieber终于横空出世、一举惊动全球，透露了他将成为下个世代音乐掌门人的气息。经过13年的熏陶和冶炼，Justin Bieber已站稳乐坛首席流行巨星的位阶，成为了货真价实的当代流行音乐之王；如今全球将迎来他睽违5年的最新作品，绝对是他另一个音乐巅峰的起点。\n\n2007年正式出道，2010以一曲“Baby”创下震惊全球的纪录，Justin Bieber之后陆续再以“Somebody to Love”、“U Smile”、“Boyfriend”、“Beauty and a Beat”、“What Do You Mean？”、“Sorry”、“Love Yourself”等单曲，以及连续四张冠军专辑【My World 2.0】、【Under the Mistletoe】、【Believe】、【Purpose】，缔造全球超过1亿张的专辑与单曲销售，并且荣获1座葛莱美奖、15座全美音乐奖、20座告示牌音乐大奖、24座MTV音乐大奖，更在YouTube上拥有超过5000万人订阅、20亿次的观看数据，在在都证明Justin Bieber正是当代的流行音乐之王，同时也是承接过去与启发未来的超级巨星。2020年1月27日，Justin Bieber在YouTube上释出纪录片形式的网络传记【Justin Bieber: Seasons】，该剧忠实纪录Justin Bieber出道至今的一切，他的人生高峰与低潮、他在众人面前的荒唐与改变，同时也揭露他对于音乐的执着和渴望，让人见识到这个曾经癫狂不羁的超级巨星最私密的内心世界。\n\n越多的人生经验和体悟，越能刻划出不朽的音乐作品；酝酿了5年、1800个日子，Justin Bieber在情人节的这一天释出全新专辑【Changes】，也率先被权威乐评滚石杂志、富比士册封为「2020最期待专辑」，无疑是今年乐坛最引颈期盼的一张专辑。Justin Bieber表示：「这几年我的生活改变了很多，我结婚、重新回到工作，而多年以来我觉得最具有挑战的时刻，往往就是开始制作新音乐的时候。随着我年纪增长，我发现到我似乎没有好好善用我的天赋，这不只是关于我自己，而是关于帮助其他正在经历苦难的人」，怀抱着宏大的愿景、剧烈的人生关转变，越趋成熟的Justin Bieber透过音乐证明自己的改变。【Changes】请到了葛莱美大师人物Boi-1da（Drake、Eminem、Kendrick Lamar）、加拿大鬼才Murda Beatz（Travis Scott、Migos）、当代王牌操盘手Vinylz（Jay Z、Nicki Minaj）等人，联手为Justin Bieber共同打造下一个世代流行音乐的典范；率先登场、成为首支主打单曲的“Yummy”，以R&B打底、结合当代的流行风潮，破亿点听秒登告示牌数位排行冠军，一举成为「史上拥有最多数位冠军单曲歌手」；与性感歌姬Kehlani合作的“Get Me”，创下YouTube超过400万观看，释出仅短短1周便在Spotify突破千万串流，更闯入告示牌潜质单曲榜的Top 20，成为专辑中的一大亮点；由新世代饶舌巨星Quavo帮腔的“Intentions”，满载着New School的Trap兴味，结合Justin Bieber独步全球的歌喉，奠基一首乐坛的超级杰作；另外专辑更力邀串流霸主Post Malone巨星马龙、嘻哈潮流王者Travis Scott、Lil Dicky等联手合作，【Changes】不仅会成为改变音乐世界的关键专辑，更会是Justin Bieber音乐生涯的全新高峰。', '2020-02-14', 280.00, 100, 0, 1, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (86891768, 'Mind Is The Magic (Anthem For The Las Vegas Show)', 'Michael Jackson', 'https://p3.music.126.net/SD2uDZ3VBf18hfPprCQjtg==/109951164846112109.jpg', NULL, '2020-04-03', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (93625092, 'Remeber the Time (Remix)', 'Michael Jackson', 'https://p3.music.126.net/osmXLbT9oIFUqB31nv3-Fw==/109951165212887038.jpg', NULL, '2020-08-12', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (95611190, 'Holy', 'Justin Bieber', 'https://p3.music.126.net/0O1DSaOFQDa0XAL1oxBDfg==/109951165325140747.jpg', '纽约9月15日，格莱美奖得主、全球巨星Justin Bieber正式确认发布全新的音乐，他与说唱歌手Chance the Rapper合作新单“Holy”今日发布，这首歌标志着Bieber重返流行乐舞台。就在几个月前，Bieber与Quavo合作的8X白金单曲《Intentions》在6月登上了电台榜TOP40的冠军位置，这也是他音乐生涯中第七次登上Billboard Pop Songs Chart冠军。该单曲还请到Colin Tilley执导的短片。\n《Changes》，Justin Bieber在今年2月发行的第五张录音室专辑，在发行首周空降Billboard 200排行榜冠军。作为Bieber的第7次夺冠专辑，该专辑还首次空降Billboard R&B Album排行榜冠军。此外，这张专辑在英国和加拿大地区登顶榜首，并在Apple Music上，覆盖85个地区排行榜冠军位置，突显了该作品在全球范围的领衔地位。《Changes》在全球已经写下超过400万张专辑折合销量。\n拥有每月超过6500万次的Spotify听众，Justin Bieber已是该平台上收听次数最多的歌手。最近，他在Instagram上的粉丝超过了惊人的1.47亿人，在YouTube上的订阅者超过了5000万人，这令他在该平台遥遥领先。\n在他的职业生涯中，Justin Bieber已在全球已经积累了超过680亿的流量播放量以及超过6800万张的专辑折合销量。\n', '2020-09-18', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (96590962, 'Michael Jackson FM Broadcast September 1987', 'Michael Jackson', 'https://p4.music.126.net/LqRkCBgl0BrryFix3GyLjQ==/109951165379606568.jpg', NULL, '2020-10-09', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (96880875, 'Lonely', 'Justin Bieber', 'https://p3.music.126.net/2ztAT9l4eOZeEUfcsqmBkA==/109951165393210183.jpg', 'Justin Bieber联手Benny Blanco新单《Lonely》发布。\n', '2020-10-16', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (96881053, 'Lonely', 'Justin Bieber', 'https://p4.music.126.net/Y_p1vLn7eW2hBi_wXBW_Ew==/109951165393216340.jpg', NULL, '2020-10-16', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (97934805, 'Holy (Acoustic)', 'Justin Bieber', 'https://p4.music.126.net/-dkVL8aL2dDMfeNJ0FqKiw==/109951165441066043.jpg', 'Justin Bieber联手Chance the Rapper新单《Holy》不插电版本发布。\n', '2020-11-05', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (99127353, 'Home for Christmas', 'Justin Bieber', 'https://p4.music.126.net/ZMkgJyzWMdIsntGPn_bG5g==/109951168144960102.jpg', 'Justin Bieber圣诞节特别EP《Home for Christmas》发布。\n', '2020-12-04', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (121043727, 'Anyone', 'Justin Bieber', 'https://p4.music.126.net/_KOvl0AK5gTroPRl0tADKg==/109951165594837531.jpg', '迎接新年的到来，全球超级巨星Justin Bieber将全新单曲《Anyone》这一礼物送给全世界的粉丝们。这首歌曲由Andrew Watt联合创作并制作，MV由Colin Tilley执导。该新单曲已在Bieber的T-Mobil跨年直播演唱会上首秀。\n\n\n“通过向全世界的粉丝分享新单的方式与大家一起告别2020，迎接2021年，我想不出比这更好的方式了，”Bieber说道 “今年，音乐让我们所有人都经历了许多，对我个人来说，音乐治愈了心灵，改变了一切。《Anyone》是一首特别的、充满希望的歌曲。它为充满希望，更为光明的新年和可能性定下了基调。”\n\nJustin Bieber在2020年发布了三首热门单曲，“Holy”,“Lonely”,和“Monster”。他是全球最受欢迎的音乐人之一，在YouTube上拥有近6000万订阅者，以超过7800万月度听众量成为Spotify全球收听量第2高的音乐人。他于2020年发布的专辑《Changes》使得他收获三项格莱美音乐奖提名，赢得一项全美音乐奖。\n\n《Changes》是格莱美奖得主，全球超级巨星Justin Bieber的第五张录音室专辑，首周空降美国专辑排行榜冠军，全球首周折合净销量超过100万。这张Bieber的第七张冠军专辑也在Billboard R&B Album 排行榜首周空降冠军，成为他在该榜上的首次冠军成绩。另外《Changes》也在英国和加拿大地区拿下冠军专辑成绩，并且在85个地区/国家的iTunes登上榜首，突显这张专辑在全球的强势地位。\n\n悉数Justin Bieber的职业成就，他已在全球收获了超过500亿的流媒体播放量和超过6000万张的专辑折合销量。他于2015年发布，格莱美获奖专辑《PURPOSE》全球销量已超过2100万张。\n', '2021-01-01', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (121993236, 'Lonely (Acoustic)', 'Justin Bieber', 'https://p4.music.126.net/e7qzUAHh8VdcHHfDDGM4VA==/109951165667333066.jpg', 'Justin Bieber联手Benny Blanco单曲“Lonely”不插电版发布。\n', '2020-10-27', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (123629087, 'JB6', 'Justin Bieber', 'https://p3.music.126.net/SR3lyJRyhLzsxqlOopYHdw==/109951168146224902.jpg', 'Justin Bieber第六张专辑《Justice》预热EP《JB6》释出，收录新专辑三首先行曲目《Holy》《Lonely》《Anyone》以及两首不插电单曲，专辑《Justice》将于3月19号全球发行！\n', '2021-02-26', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (123857369, 'Hold On', 'Justin Bieber', 'https://p4.music.126.net/X3JDVmaTdzV4gD5Ek3fkAA==/109951165778951399.jpg', '继《Holy》,《Lonely》和 《Anyone》之后，格莱美得主，世界超级巨星Justin Bieber带来全新单曲《Hold On》以及MV，他的第六张LP专辑《Justice》将在3月19日发行。\n', '2021-03-05', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (123858074, 'Justice (中国豪华特别版)', 'Justin Bieber', 'https://p4.music.126.net/_d1i74E6x-zTTnEmdVjEwA==/109951165835207944.jpg', '在2020年的专辑《Changes》里，新婚不久的Justin Bieber热情赞美了爱与信仰的治愈之力，用感性、清澈的R&B抒情歌讲述奉献、承诺与内心平静的主题。他的第六张专辑《Justice》延续了这一叙事，但对于这位炙手可热的国际流行明星来说，新专辑的灵感来源可能更加出人意料——放下工作，好好休息。\n\n和所有人一样，Bieber在2020年也一直足不出户，由于全球疫情的原因无法旅行或巡演。但他没有迷失在社交媒体无休无止的坏消息里，而是欣然选择了更为平和的生活方式：丢掉手机，全心投入心理治疗，每晚六点后便停止工作，专心陪伴妻子Hailey。这种改变令他脱胎换骨，也为我们带来了一系列柔情蜜意的80年代风格流行曲《Deserve You》《Anyone》和寻求原谅、深沉坦诚的抒情歌《Hold On》《Lonely》。从这些作品中，不难听出走出困境的Bieber那份发自心底的满意与知足。\n\nBieber喜欢用美满的婚姻作为自己生活幸福的标志，但这些歌不只是浪漫情歌而已。他唱的可能是将自己从危机边缘拉回来的任何因素——宗教、观念、和平与宁静的心态。在2020年的一部纪录片里，他曾坦承自己经历过一段令他“真的很想自杀”的精神健康危机，现在，心中满怀感恩与谦逊的Bieber听起来对自己的好运气一清二楚。“Never know when my mind\'s gonna turn on me/But you\'re the one I call for security”，他在与The Kid LAROI合作的《Unstable》中这样唱道，“Through everything you\'ve been my rock/I think you\'re the only thing I didn\'t get wrong”。他在专辑中与Khalid合作了《As I Am》，与Dominic Fike合作了《Die For You》，与BEAM合作了《Love You Different》，与Burna Boy合作了《Loved By You》。在这些真情流露的流行歌之余，他为以前那个自私的自己深表歉意，并承诺会变得更好。他在《2 Much》里深情唱道：“I still relive the second I met my biggest blessing/Prayed for you/And look what God has done。”\n\nJustin Bieber最新专辑《Justice》中国豪华特别版 - TRIPLE CHUCKS DELUXE现已发布！相较之前新增六首曲目，助阵阵容扩大！新阵容嘉宾包括：Lil Uzi Vert，Jaden Smith，Quavo，DaBaby以及Tori Kelly。流媒体方面，《Justice》曾在发布后48小时内累计收获1.6亿次流媒体量。\n\n“在世界面临许多问题的时刻，我们都渴望为人类疗伤以及伸张正义。在创作这张专辑的过程中，我的目标是创作出能让人感到舒服，能与人们产生共鸣与联系的音乐，让他们感觉不再那么孤独。饱受苦楚、不公和痛苦会让人们感到无助。音乐是能让人们意识到彼此间并不孤单的很好方式。音乐也可以成为人与人之间情感相连的一种途径。我知道，我不能仅仅通过创作音乐来解决不公正的问题，但我明白，如果我们都能善用自己的能力，尽自己一份力，去善待这个世界，那么我们距离团结就更近了一步。以我微薄之力尽我所能，我想继续探讨正义模样的话题，这样我们就能继续去改善。” ——Justin Bieber\n\n\n', '2021-03-26', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (125595927, 'Freedom.', 'Justin Bieber', 'https://p4.music.126.net/8oOZQG5H2UrpVCM2NQu5kw==/109951165864222948.jpg', '紧随第六张冠军专辑《Justice》之后，Justin Bieber于西方复活节之际无预警空降福音灵感启发的EP《Freedom.》，包含六首全新曲目，Brandon Love, Chandler Moore, Judah Smith, Lauren Walters, Pink Sweat$以及Tori Kelly参与献声助阵！\n', '2021-03-25', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (125595932, 'Freedom.', 'Justin Bieber', 'https://p4.music.126.net/e5-XMkQbU6E3hvNK0Nr8IA==/109951165864222957.jpg', NULL, '2021-03-25', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (128520090, 'Peaches (Remix)', 'Justin Bieber', 'https://p3.music.126.net/jilM347hfbYU5nid7mJ--w==/109951166064752175.jpg', 'Justin Bieber第六张冠军大碟《Justice》热门单曲《Peaches》混音版本新鲜出炉，非裔美国说唱歌手Ludacris、R&B流行天王亚瑟小子Usher已经嘻哈巨星Snoop Dogg助阵献声，三位大咖的助阵耳目一新，加持热度助力再度冲榜！\n', '2021-06-07', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (128520091, 'Peaches (Remix)', 'Justin Bieber', 'https://p4.music.126.net/W8uEjFz3BYrQI2KTWTCsoA==/109951166064750265.jpg', 'Justin Bieber第六张冠军大碟《Justice》热门单曲《Peaches》混音版本新鲜出炉，非裔美国说唱歌手Ludacris、R&B流行天王亚瑟小子Usher已经嘻哈巨星Snoop Dogg助阵献声，三位大咖的助阵耳目一新，加持热度助力再度冲榜！\n', '2021-06-07', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (129525671, 'Peaches (Masterkraft Remix)', 'Justin Bieber', 'https://p3.music.126.net/pE1gFIAocej5kuwxaFHS2g==/109951166119855369.jpg', NULL, '2021-06-25', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (129525672, 'Peaches (Masterkraft Remix)', 'Justin Bieber', 'https://p3.music.126.net/zTKLxiiGaBaNkXDkWud_lQ==/109951166119861217.jpg', 'Justin Bieber专辑《Justice》热门单曲《Peaches》再添新混音版本，邀请尼日利亚两位说唱歌手Alpha P以及Omah lay助阵献声。\n', '2021-06-25', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (134452373, 'Justice (The Complete Edition)', 'Justin Bieber', 'https://p3.music.126.net/SELca2rh7Y2jB_3Q_UyYqg==/109951166501256926.jpg', 'Justin Bieber第六张冠军大碟《Justice》完整版上线，相比中国豪华特别版新增《Red Eye》以及《Hailey》两首全新单曲，同时单曲《Ghost》音乐录像带同步上线！\n', '2021-10-08', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (134452379, 'Justice (The Complete Edition)', 'Justin Bieber', 'https://p3.music.126.net/9XGnCuz62zUD-zezLu1vmA==/109951166501259451.jpg', 'Justin Bieber第六张冠军大碟《Justice》完整版上线，相比中国豪华特别版新增《Red Eye》以及《Hailey》两首全新单曲，同时单曲《Ghost》音乐录像带同步上线！\n', '2021-10-08', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (135425606, 'Rockin\' Around The Christmas Tree', 'Justin Bieber', 'https://p4.music.126.net/9TJ5eF4LG5m5mY5yA1YavQ==/109951166566455673.jpg', 'Johnny Marks的经典圣诞单曲\"Rockin\' Around The Christmas Tree\"是Justin Bieber庆祝圣诞佳节时喜爱的歌曲之一，小贾表示很开心与大家分享自己所演绎的版本~在这美好的节日气氛烘托下，与所爱之人共度浪漫时光吧~\n', '2020-11-12', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (144051429, 'I Feel Funny', 'Justin Bieber', 'https://p4.music.126.net/FUliGiIQ3VpZkp8CfKEf0Q==/109951167344943304.jpg', '比伯Justin Bieber《I Feel Funny》惊喜上线！\n', '2022-04-27', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (144052285, 'I Feel Funny', 'Justin Bieber', 'https://p4.music.126.net/UI-DNdhcHTI1q0DNHDTRGw==/109951167344941944.jpg', '比伯Justin Bieber《I Feel Funny》惊喜上线！', '2022-04-26', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (144185625, 'Honest', 'Justin Bieber', 'https://p3.music.126.net/nV4-lqVtG5M3NJBXggXgdw==/109951167353603340.jpg', '流行天王Justin Bieber回归！2022年4月28日，继《Don\'t Go》合作后，Justin Bieber再次联手嘻哈歌手 Don Toliver 发布全新嘻哈单曲《Honest》，熟悉的R&B曲风融合了trap与嘻哈元素，让整首歌曲层次更加丰富，Bieber用更具匠心的音乐作品宣告着回归 。全新单曲发布前一天，比伯略显“调皮”，惊喜空降，发布了《I Feel Funny》作为该单曲的预热，同时还发布了一段《Honest》拍摄现场的幕后视频，由《Honest》MV导演Cole Bennett 手机拍摄完成。\n', '2022-04-29', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (144185643, 'Honest', 'Justin Bieber', 'https://p3.music.126.net/-bfhIlyAmdBuvoPIpPfXRg==/109951167353604357.jpg', '流行天王Justin Bieber回归！2022年4月28日，继《Don\'t Go》合作后，Justin Bieber再次联手嘻哈歌手 Don Toliver 发布全新嘻哈单曲《Honest》，熟悉的R&B曲风融合了trap与嘻哈元素，让整首歌曲层次更加丰富，Bieber用更具匠心的音乐作品宣告着回归 。全新单曲发布前一天，比伯略显“调皮”，惊喜空降，发布了《I Feel Funny》作为该单曲的预热，同时还发布了一段《Honest》拍摄现场的幕后视频，由《Honest》MV导演Cole Bennett 手机拍摄完成。\n', '2022-04-28', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (150619347, 'Beautiful Love (Free Fire)', 'Justin Bieber', 'https://p3.music.126.net/6O7z076ybQqsUSLiaFvvzw==/109951167829563569.jpg', '小贾Justin Bieber与游戏Free Fire (我要活下去) 梦幻联动，带来全新单曲《Beautiful Love》，Bieber将在游戏的五周年活动中现场演绎该新单《Beautiful Love》，同时还为其量身定制了一套新皮肤。\n', '2022-08-30', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (155116994, 'Thriller 40', 'Michael Jackson', 'https://p4.music.126.net/DOtaUFeUL2X9IItz4MVXNg==/109951168068405893.jpg', '★世界流行之王Michael Jackson\n★经典再现纪念专辑Thriller发行40周年\n★收录原始完整专辑+多首从未公布曲目\n由索尼音乐联合迈克尔·杰克逊遗产管理委员会发行纪念《Thriller》40周年豪华版专辑，这张具有时代意义的专辑也是迈克尔·杰克逊最具代表性的作品，曾获吉尼斯世界纪录认证，被称为是“史上销量最高专辑”，也是世界流行音乐史上难以逾越的经典之作。此次40周年豪华版纪念专辑不仅收录了包括《Thriller》、《Billie Jean》以及《Beat It》等在内的原始专辑完整曲目，而且还收录了迈克尔·杰克逊从未公布过的多首音乐作品。\n', '2022-11-18', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (158278421, 'Michael Jackson - Manilla Phillipines TV Broadcast December 1996 Part One.', 'Michael Jackson', 'https://p4.music.126.net/J0IlM7tE_w4Edsp2Wm6EIg==/109951168236200455.jpg', NULL, '2021-03-26', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (158279235, 'Michael Jackson - Manilla Phillipines TV Broadcast December 1996 Part Two.', 'Michael Jackson', 'https://p4.music.126.net/pMcGz5z87GpuncLyRjZlAQ==/109951168236210023.jpg', NULL, '2021-03-26', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (158279244, 'Michael Jackson - Yokohama Japan TV Broadcast September 1987 Part Two.', 'Michael Jackson', 'https://p3.music.126.net/NUqe7OB5WEx19S7uraVcIQ==/109951168236207734.jpg', NULL, '2021-03-26', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (158279265, 'Michael Jackson - Yokohama Japan TV Broadcast September 1987 Part One.', 'Michael Jackson', 'https://p3.music.126.net/QxC6-uS5GiBGcDvdfjjp_g==/109951168236216102.jpg', NULL, '2021-03-26', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (167959098, 'MICHAEL JACKSON - Live in Los Angeles 1989 (Live)', 'Michael Jackson', 'https://p3.music.126.net/gBRXRzkWXlxFDonh97fv2Q==/109951168688795270.jpg', NULL, '2023-06-22', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (171812353, 'Beat It (Necola Remix)', 'Michael Jackson', 'https://p3.music.126.net/pZyL953d8PyqdlEyL8WSTQ==/109951168826988777.jpg', NULL, '2017-09-01', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (186621345, 'バッド・ワールド・ツアー・イン・ロサンゼルス１９８９ (Live)', 'Michael Jackson', 'https://p3.music.126.net/k7bnwGkia314735fzpuN9w==/109951169354611311.jpg', NULL, '2023-01-20', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (258371520, 'ライヴ・イン・ジャパン１９８７ (Live)', 'Michael Jackson', 'https://p4.music.126.net/NjTvoAU3p7sSG2-fWlE5ig==/109951170333515559.jpg', NULL, '2018-09-01', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (277997436, 'SWAG', 'Justin Bieber', 'https://p4.music.126.net/KnF8pyIpQp_Kc_PjoFN5-g==/109951172010103985.jpg', '全球流行天王 Justin Bieber 正式回归，个人第七张录音室专辑 《SWAG》 重磅发行！\n\n全新专辑共收录 21 首曲目，由 Justin Bieber 携手 Carter Lang、Dylan Wiggins、Daniel Caesar、Dijon、mk.gee、Daniel Chetrit、Eddie Benjamin、Knox Fortune 等众多才华横溢的音乐人共同打造。专辑灵感源自 Justin Bieber 作为丈夫与父亲的身份经历，全新歌曲篇章展现了其个人更加深邃的内心世界与细腻的音乐表达，也标志着他音乐生涯中最为私人化的一次创作旅程。', '2025-07-11', 280.00, 100, 0, 1, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (277997444, 'SWAG', 'Justin Bieber', 'https://p4.music.126.net/XlyCAKPZzGyCH5_E7YLWDw==/109951171444077096.jpg', '全球流行天王 Justin Bieber 正式回归，个人第七张录音室专辑 《SWAG》 重磅发行！\n\n全新专辑共收录 21 首曲目，由 Justin Bieber 携手 Carter Lang、Dylan Wiggins、Daniel Caesar、Dijon、mk.gee、Daniel Chetrit、Eddie Benjamin、Knox Fortune 等众多才华横溢的音乐人共同打造。专辑灵感源自 Justin Bieber 作为丈夫与父亲的身份经历，全新歌曲篇章展现了其个人更加深邃的内心世界与细腻的音乐表达，也标志着他音乐生涯中最为私人化的一次创作旅程。', '2025-07-11', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (284075851, 'SWAG II', 'Justin Bieber', 'https://p3.music.126.net/mwPwZnsXPLjaHn_vzSg-ag==/109951171976648244.jpg', '继横扫各大榜单的专辑《SWAG》问世仅数周，全球流行天王Justin Bieber携新专辑《SWAG II》强势回归，继续引领潮流之声。此次23首全新作品中，Justin Bieber不仅亲自担纲制作，更携手Carter Lang、Dylan Wiggins、Dijon、mk.gee、Mike Will、Camper等创作人共同打造，全面释放更大胆、更先锋的音乐能量并拓宽创意边界。🩷\n\n2025年7月专辑上线当天，《SWAG》即登顶全球流媒体最畅销专辑榜，并拿下美国公告牌流行/R&B专辑榜三榜冠军，成为Justin Bieber生涯第10张美国公告牌专辑榜Top 5专辑，也标志着他第50支公告牌全球单曲榜热曲诞生。主打曲《DAISIES》更一举夺得Spotify美国与全球双榜冠军，发行后连续7日高居榜首，同时霸榜Apple Music全球歌曲榜单，成为本年度播放量最高的单曲之一。', '2025-09-05', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (285096821, 'SWAG II', 'Justin Bieber', 'https://p4.music.126.net/3iL5qX5KFzY4CWYbnvVztA==/109951172019706296.jpg', NULL, '2025-09-05', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (369123751, 'Michael: The Birth of A Superstar', 'Michael Jackson', 'https://p4.music.126.net/BqquH3Vc29kRmgpwHLGnUA==/109951172987100623.jpg', NULL, '2026-04-03', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (372193574, 'Michael: Songs From The Motion Picture', 'Michael Jackson', 'https://p3.music.126.net/9GuvCtJb8JQ76SyhQ_L-vg==/109951173098205295.jpg', '《Michael: Songs From the Motion Picture》作为传记电影《Michael》的官方原声专辑，精心收录影片中 13 首经典曲目，横跨Jackson 5、The Jacksons时期，直至迈克尔・杰克逊个人巅峰之作。《Off The Wall》《Thriller》《Billie Jean》《Don’t Stop ’Til You Get Enough》《Human Nature》等传世金曲悉数收录，再现一代流行天王的传奇音乐之路。', '2026-04-24', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (383765118, 'SWAG LIVE FROM COACHELLA (Weekend I)', 'Justin Bieber', 'https://p3.music.126.net/b140F7rVmy3gzEPMgRs4rw==/109951173459666089.jpg', 'Justin Bieber 推出全新现场专辑《SWAG LIVE FROM COACHELLA (WEEKEND I)》，完整收录他在2026年Coachella音乐节首个周末的压轴演出。这不仅是Justin Bieber 时隔四年重返大型舞台，也成为科切拉历史上最受瞩目的演出之一，现场融合《SWAG》时代新作、经典金曲、原声演绎以及珍贵影像回顾，并邀请 The Kid LAROI、Tems、Wizkid、Dijon 与 Mk.gee 惊喜助阵，完整呈现这场载入生涯的重要演出。', '2026-06-26', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);
INSERT INTO `album` VALUES (385010222, 'SWAG LIVE FROM COACHELLA (Weekend II)', 'Justin Bieber', 'https://p3.music.126.net/qi7PPnA6R2o1bGzy2QXmGQ==/109951173498467113.jpg', NULL, '2026-07-03', 280.00, 100, 0, 1, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31', 'PHYSICAL', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '盲盒配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of blind_box
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '盲盒奖品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of blind_box_prize
-- ----------------------------

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
  `probability_at_draw` decimal(10, 6) NULL DEFAULT NULL COMMENT 'Configured probability captured for audit',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_box_id`(`box_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '抽奖记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of draw_record
-- ----------------------------
INSERT INTO `draw_record` VALUES (1, 3, 2, 11, 'R Sticker', 3, 2, 0, '2026-10-29 10:53:36', 30.000000);
INSERT INTO `draw_record` VALUES (2, 3, 2, 9, 'SSR Figure', 1, 3, 0, '2026-10-29 10:53:36', 5.000000);
INSERT INTO `draw_record` VALUES (3, 3, 2, 12, 'N Card', 4, 4, 0, '2026-10-29 10:53:36', 50.000000);
INSERT INTO `draw_record` VALUES (4, 3, 2, 12, 'N Card', 4, 5, 0, '2026-10-29 10:53:36', 50.000000);
INSERT INTO `draw_record` VALUES (5, 3, 2, 12, 'N Card', 4, 6, 0, '2026-10-29 10:53:36', 50.000000);
INSERT INTO `draw_record` VALUES (6, 3, 2, 12, 'N Card', 4, 7, 0, '2026-10-29 10:53:36', 50.000000);
INSERT INTO `draw_record` VALUES (7, 3, 2, 12, 'N Card', 4, 8, 0, '2026-10-29 10:53:36', 50.000000);
INSERT INTO `draw_record` VALUES (8, 3, 2, 10, 'SR Acrylic', 2, 9, 0, '2026-10-29 10:53:36', 15.000000);
INSERT INTO `draw_record` VALUES (9, 3, 2, 10, 'SR Acrylic', 2, 10, 0, '2026-10-29 10:53:36', 15.000000);
INSERT INTO `draw_record` VALUES (10, 3, 2, 11, 'R Sticker', 3, 11, 0, '2026-10-29 10:53:36', 30.000000);
INSERT INTO `draw_record` VALUES (11, 3, 2, 24, 'N Card', 4, 12, 0, '2026-10-29 10:58:26', 50.000000);
INSERT INTO `draw_record` VALUES (12, 3, 2, 24, 'N Card', 4, 13, 0, '2026-10-30 14:52:46', 50.000000);

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
  `order_type` tinyint NOT NULL DEFAULT 1 COMMENT '订单形态：1-专辑订单，2-盲盒订单',
  `blind_box_id` bigint NULL DEFAULT NULL COMMENT '盲盒订单关联的盲盒ID',
  `draw_count` int NULL DEFAULT NULL COMMENT '盲盒订单抽取次数（1或10）',
  `draw_summary` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '盲盒抽取结果摘要',
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
  `product_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PHYSICAL' COMMENT 'Product type captured at order creation',
  `digital_content_accessed_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_album_id`(`album_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_expire_time`(`expire_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_info
-- ----------------------------
INSERT INTO `order_info` VALUES (4, 'ORD1793240506725272', 3, 379730914, '数字测试专辑Batch1', NULL, 2, 30.00, 60.00, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-29 10:22:13', '2026-10-29 10:36:47', NULL, 0, '2026-10-29 10:21:47', '2026-10-29 10:22:13', 'DIGITAL', NULL);
INSERT INTO `order_info` VALUES (5, 'ORD17932405588302027', 3, 379730914, '数字测试专辑Batch1', NULL, 1, 30.00, 30.00, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-29 10:23:00', '2026-10-29 10:17:38', NULL, 0, '2026-10-29 10:22:39', '2026-10-29 10:23:00', 'DIGITAL', NULL);
INSERT INTO `order_info` VALUES (6, 'ORD17932410556052668', 3, 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 1, 280.00, 280.00, 5, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', '2026-10-29 10:31:32', NULL, '2026-10-29 10:45:56', NULL, 0, '2026-10-29 10:30:56', '2026-10-29 10:31:32', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (7, 'ORD17932411228126411', 3, 7547, '收敛水', 'https://p4.music.126.net/YuS3GrLcE7PIi_3s-62ZQA==/109951168001997012.jpg', 2, 280.00, 560.00, 5, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', '2026-10-29 10:32:03', NULL, '2026-10-29 10:47:03', NULL, 0, '2026-10-29 10:32:03', '2026-10-29 10:32:03', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (8, 'ORD17932416574632322', 3, 379730914, '数字测试专辑Batch1', NULL, 1, 30.00, 870.00, 1, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', '2026-10-29 10:41:31', NULL, '2026-10-29 10:55:58', 'batch3 test', 0, '2026-10-29 10:40:58', '2026-10-29 10:40:58', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (9, 'ORD17932416909592883', 3, 379730914, '数字测试专辑Batch1', NULL, 1, 30.00, 30.00, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-29 10:57:00', '2026-10-29 10:56:31', NULL, 0, '2026-10-29 10:41:31', '2026-10-29 10:57:00', 'DIGITAL', NULL);
INSERT INTO `order_info` VALUES (10, 'ORD17932417296921604', 3, 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 2, 280.00, 840.00, 3, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', NULL, '2026-10-29 10:42:10', '2026-10-29 10:57:10', NULL, 0, '2026-10-29 10:42:10', '2026-10-29 10:42:09', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (11, 'BB17932423914767817', 3, 6293, 'TestBox2026', NULL, 10, 50.00, 500.00, 1, 2, 2, 10, 'R·R Sticker、SSR·SSR Figure、N·N Card、N·N Card、N·N Card、N·N Card、N·N Card、SR·SR Acrylic、SR·SR Acrylic、R·R Sticker', 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', '2026-10-29 10:53:36', NULL, '2026-10-29 11:08:11', NULL, 0, '2026-10-29 10:53:11', '2026-10-29 10:53:35', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (12, 'BB17932425830564700', 3, 6293, 'TestBox2026', NULL, 1, 50.00, 50.00, 3, 2, 2, 1, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', NULL, '2026-10-29 11:12:00', '2026-10-29 11:11:23', NULL, 0, '2026-10-29 10:56:23', '2026-10-29 11:12:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (13, 'BB1793242584022299', 3, 6293, 'TestBox2026', NULL, 1, 50.00, 50.00, 3, 2, 2, 1, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', NULL, '2026-10-29 10:57:00', '2026-10-29 10:51:24', NULL, 0, '2026-10-29 10:56:24', '2026-10-29 10:57:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (14, 'BB17932427046718670', 3, 6293, 'TestBox2026', NULL, 1, 50.00, 50.00, 5, 2, 2, 1, '抽取失败自动退款：盲盒暂无奖品配置', 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', '2026-10-29 10:58:25', NULL, '2026-10-29 11:13:25', NULL, 0, '2026-10-29 10:58:25', '2026-10-29 10:58:25', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (15, 'BB17932427057841153', 3, 6293, 'TestBox2026', NULL, 1, 50.00, 50.00, 5, 2, 2, 1, 'N·N Card', 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', '2026-10-29 10:58:26', NULL, '2026-10-29 11:13:26', NULL, 0, '2026-10-29 10:58:26', '2026-10-29 10:58:26', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (16, 'BB1793242751876217', 3, 6293, 'TestBox2026', NULL, 1, 50.00, 50.00, 3, 2, 2, 1, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', NULL, '2026-10-29 11:15:00', '2026-10-29 11:14:12', NULL, 0, '2026-10-29 10:59:12', '2026-10-29 11:15:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (17, 'BB17932434526489571', 3, 6293, 'TestBox2026', NULL, 1, 50.00, 50.00, 3, 2, 2, 1, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', NULL, '2026-10-29 11:26:00', '2026-10-29 11:25:53', NULL, 0, '2026-10-29 11:10:53', '2026-10-29 11:26:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (18, 'ORD1793326066441378', 3, 379730914, '数字测试专辑Batch1', NULL, 1, 30.00, 30.00, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-30 10:23:00', '2026-10-30 10:22:46', NULL, 0, '2026-10-30 10:07:46', '2026-10-30 10:23:00', 'DIGITAL', NULL);
INSERT INTO `order_info` VALUES (19, 'ORD17933261482193699', 3, 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 1, 280.00, 280.00, 3, 1, NULL, NULL, NULL, 'PM Tester', '13800001234', 'Beijing', 'Beijing', 'Haidian', 'PM Street No.1', NULL, '2026-10-30 10:25:00', '2026-10-30 10:24:08', NULL, 0, '2026-10-30 10:09:08', '2026-10-30 10:25:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (20, 'ORD1793328405647134', 3, 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 1, 280.00, 280.00, 3, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', NULL, '2026-10-30 11:02:00', '2026-10-30 11:01:46', NULL, 0, '2026-10-30 10:46:46', '2026-10-30 11:02:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (21, 'ORD17933301772741181', 3, 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 1, 280.00, 280.00, 3, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', NULL, '2026-10-30 14:01:00', '2026-10-30 11:31:17', NULL, 0, '2026-10-30 11:16:17', '2026-10-30 14:01:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (22, 'ORD17933302459914498', 3, 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 1, 280.00, 280.00, 5, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', '2026-10-30 11:17:26', NULL, '2026-10-30 11:32:26', NULL, 0, '2026-10-30 11:17:26', '2026-10-30 11:17:27', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (23, 'ORD17933400656247502', 3, 379730914, '数字测试专辑Batch1', NULL, 1, 30.00, 30.00, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-30 14:17:00', '2026-10-30 14:16:06', NULL, 0, '2026-10-30 14:01:06', '2026-10-30 14:17:00', 'DIGITAL', NULL);
INSERT INTO `order_info` VALUES (24, 'ORD17933401802136117', 3, 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 1, 280.00, 280.00, 3, 1, NULL, NULL, NULL, 'PM Tester', '13800001234', 'Beijing', 'Beijing', 'Haidian', 'PM Street No.1', NULL, '2026-10-30 14:18:00', '2026-10-30 14:18:00', NULL, 0, '2026-10-30 14:03:00', '2026-10-30 14:18:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (25, 'ORD17933405017479363', 3, 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 1, 280.00, 280.00, 3, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', NULL, '2026-10-30 14:24:00', '2026-10-30 14:23:22', NULL, 0, '2026-10-30 14:08:22', '2026-10-30 14:24:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (26, 'ORD17933406567996926', 3, 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 1, 280.00, 280.00, 5, 1, NULL, NULL, NULL, 'PM Tester', '13800001234', 'Beijing', 'Beijing', 'Haidian', 'PM Street No.1', '2026-10-30 14:15:31', NULL, '2026-10-30 14:25:57', NULL, 0, '2026-10-30 14:10:57', '2026-10-30 14:16:30', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (27, 'ORD17933415707883417', 3, 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 1, 280.00, 280.00, 5, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', '2026-10-30 14:26:12', NULL, '2026-10-30 14:41:11', NULL, 0, '2026-10-30 14:26:11', '2026-10-30 14:26:12', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (28, 'ORD17933416786448081', 3, 13361, 'Wake Up', 'https://p3.music.126.net/WSEF8SEpWa_cmqk53G1HTQ==/90159953489772.jpg', 1, 280.00, 280.00, 3, 1, NULL, NULL, NULL, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', NULL, '2026-10-30 14:43:00', '2026-10-30 14:42:59', NULL, 0, '2026-10-30 14:27:59', '2026-10-30 14:43:00', 'PHYSICAL', NULL);
INSERT INTO `order_info` VALUES (29, 'BB17933430276436254', 3, 6293, 'TestBox2026', NULL, 1, 50.00, 50.00, 1, 2, 2, 1, 'N·N Card', 'PM Tester', '13800001234', 'Beijing', 'Beijing', 'Haidian', 'PM Street No.1', '2026-10-30 14:52:46', NULL, '2026-10-30 15:05:28', 'postman batch4', 0, '2026-10-30 14:50:28', '2026-10-30 14:52:46', 'PHYSICAL', NULL);

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `album_id` bigint NOT NULL COMMENT '专辑ID',
  `album_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '专辑名称快照',
  `album_cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '专辑封面快照',
  `price` decimal(10, 2) NOT NULL COMMENT '成交单价快照',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '购买数量',
  `subtotal` decimal(10, 2) NOT NULL COMMENT '小计=单价x数量',
  `product_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PHYSICAL' COMMENT '商品形态快照：PHYSICAL-实物，DIGITAL-数字',
  `digital_content_accessed_at` datetime NULL DEFAULT NULL COMMENT '数字内容首次取阅时间（明细级退款闸门）',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单明细表（多商品订单）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (1, 8, 'ORD17932416574632322', 379730914, '数字测试专辑Batch1', NULL, 30.00, 1, 30.00, 'DIGITAL', '2026-10-29 10:41:32', 0, '2026-10-29 10:40:58', '2026-10-29 10:40:58');
INSERT INTO `order_item` VALUES (2, 8, 'ORD17932416574632322', 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-29 10:40:58', '2026-10-29 10:40:58');
INSERT INTO `order_item` VALUES (3, 8, 'ORD17932416574632322', 7547, '收敛水', 'https://p4.music.126.net/YuS3GrLcE7PIi_3s-62ZQA==/109951168001997012.jpg', 280.00, 2, 560.00, 'PHYSICAL', NULL, 0, '2026-10-29 10:40:58', '2026-10-29 10:40:58');
INSERT INTO `order_item` VALUES (4, 9, 'ORD17932416909592883', 379730914, '数字测试专辑Batch1', NULL, 30.00, 1, 30.00, 'DIGITAL', NULL, 0, '2026-10-29 10:41:31', '2026-10-29 10:41:31');
INSERT INTO `order_item` VALUES (5, 10, 'ORD17932417296921604', 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 280.00, 2, 560.00, 'PHYSICAL', NULL, 0, '2026-10-29 10:42:10', '2026-10-29 10:42:10');
INSERT INTO `order_item` VALUES (6, 10, 'ORD17932417296921604', 13352, '贫民百万歌星', 'https://p4.music.126.net/Js-ZQub2-4_RA176YXwm5g==/119846767440816.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-29 10:42:10', '2026-10-29 10:42:10');
INSERT INTO `order_item` VALUES (7, 18, 'ORD1793326066441378', 379730914, '数字测试专辑Batch1', NULL, 30.00, 1, 30.00, 'DIGITAL', NULL, 0, '2026-10-30 10:07:46', '2026-10-30 10:07:46');
INSERT INTO `order_item` VALUES (8, 19, 'ORD17933261482193699', 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-30 10:09:08', '2026-10-30 10:09:08');
INSERT INTO `order_item` VALUES (9, 20, 'ORD1793328405647134', 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-30 10:46:46', '2026-10-30 10:46:46');
INSERT INTO `order_item` VALUES (10, 21, 'ORD17933301772741181', 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-30 11:16:17', '2026-10-30 11:16:17');
INSERT INTO `order_item` VALUES (11, 22, 'ORD17933302459914498', 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-30 11:17:26', '2026-10-30 11:17:26');
INSERT INTO `order_item` VALUES (12, 23, 'ORD17933400656247502', 379730914, '数字测试专辑Batch1', NULL, 30.00, 1, 30.00, 'DIGITAL', NULL, 0, '2026-10-30 14:01:06', '2026-10-30 14:01:06');
INSERT INTO `order_item` VALUES (13, 24, 'ORD17933401802136117', 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-30 14:03:00', '2026-10-30 14:03:00');
INSERT INTO `order_item` VALUES (14, 25, 'ORD17933405017479363', 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-30 14:08:22', '2026-10-30 14:08:22');
INSERT INTO `order_item` VALUES (15, 26, 'ORD17933406567996926', 6293, 'Super Sunshine', 'https://p3.music.126.net/c_094VESPkdcefvHOFJCZw==/107752139527257.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-30 14:10:57', '2026-10-30 14:10:57');
INSERT INTO `order_item` VALUES (16, 27, 'ORD17933415707883417', 8100, '15', 'https://p3.music.126.net/i9LpqkYOIhaYFYsIBTh8RA==/109951168870800536.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-30 14:26:11', '2026-10-30 14:26:11');
INSERT INTO `order_item` VALUES (17, 28, 'ORD17933416786448081', 13361, 'Wake Up', 'https://p3.music.126.net/WSEF8SEpWa_cmqk53G1HTQ==/90159953489772.jpg', 280.00, 1, 280.00, 'PHYSICAL', NULL, 0, '2026-10-30 14:27:59', '2026-10-30 14:27:59');

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '支付记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of payment
-- ----------------------------
INSERT INTO `payment` VALUES (1, 'PAY17932410916802C3CE003', 6, 'ORD17932410556052668', 3, 280.00, 3, 'TESTTXN001', '{out_trade_no=PAY17932410916802C3CE003, transaction_id=TESTTXN001, result_code=SUCCESS}', '2026-10-29 10:31:32', '2026-10-29 10:31:32', '2026-10-29 10:31:32', 0);
INSERT INTO `payment` VALUES (2, 'PAY179324112304132A13212', 7, 'ORD17932411228126411', 3, 560.00, 3, 'T2', '{out_trade_no=PAY179324112304132A13212, transaction_id=T2, result_code=SUCCESS}', '2026-10-29 10:32:03', '2026-10-29 10:32:03', '2026-10-29 10:32:03', 0);
INSERT INTO `payment` VALUES (3, 'PAY17932416911927788CB05', 8, 'ORD17932416574632322', 3, 870.00, 1, 'T3', '{out_trade_no=PAY17932416911927788CB05, transaction_id=T3, result_code=SUCCESS}', '2026-10-29 10:41:31', '2026-10-29 10:41:31', '2026-10-29 10:41:31', 0);
INSERT INTO `payment` VALUES (4, 'PAY17932424154219BEFF3B7', 11, 'BB17932423914767817', 3, 500.00, 1, 'MOCK1793242415507', 'mock-pay', '2026-10-29 10:53:35', '2026-10-29 10:53:36', '2026-10-29 10:53:35', 0);
INSERT INTO `payment` VALUES (5, 'PAY1793242583596DEF9B597', 12, 'BB17932425830564700', 3, 50.00, 0, NULL, NULL, '2026-10-29 10:56:24', NULL, '2026-10-29 10:56:24', 0);
INSERT INTO `payment` VALUES (6, 'PAY1793242705296F1079A78', 14, 'BB17932427046718670', 3, 50.00, 3, 'MOCK1793242705399', 'mock-pay', '2026-10-29 10:58:25', '2026-10-29 10:58:25', '2026-10-29 10:58:25', 0);
INSERT INTO `payment` VALUES (7, 'PAY17932427061139B2FDB3E', 15, 'BB17932427057841153', 3, 50.00, 3, 'MOCK1793242706195', 'mock-pay', '2026-10-29 10:58:26', '2026-10-29 10:58:26', '2026-10-29 10:58:26', 0);
INSERT INTO `payment` VALUES (8, 'PAY17932427520940B9EFD98', 16, 'BB1793242751876217', 3, 50.00, 0, NULL, NULL, '2026-10-29 10:59:12', NULL, '2026-10-29 10:59:12', 0);
INSERT INTO `payment` VALUES (10, 'PAY179332840597289222FDB', 20, 'ORD1793328405647134', 3, 280.00, 0, NULL, NULL, '2026-10-30 10:46:46', NULL, '2026-10-30 10:46:46', 0);
INSERT INTO `payment` VALUES (11, 'PAY179333017755805AA2499', 21, 'ORD17933301772741181', 3, 280.00, 0, NULL, NULL, '2026-10-30 11:16:18', NULL, '2026-10-30 11:16:18', 0);
INSERT INTO `payment` VALUES (12, 'PAY1793330246259010E020D', 22, 'ORD17933302459914498', 3, 280.00, 3, 'MOCK1793330246323', 'mock-pay', '2026-10-30 11:17:26', '2026-10-30 11:17:26', '2026-10-30 11:17:27', 0);
INSERT INTO `payment` VALUES (14, 'PAY1793340501979032836D5', 25, 'ORD17933405017479363', 3, 280.00, 0, NULL, NULL, '2026-10-30 14:08:22', NULL, '2026-10-30 14:08:22', 0);
INSERT INTO `payment` VALUES (15, 'PAY179334066688006F9EFFF', 26, 'ORD17933406567996926', 3, 280.00, 3, '2026103022001445060509202739', 'alipay-query-sync', '2026-10-30 14:11:07', '2026-10-30 14:15:31', '2026-10-30 14:16:33', 0);
INSERT INTO `payment` VALUES (16, 'PAY17933415711151FFF6E17', 27, 'ORD17933415707883417', 3, 280.00, 3, 'MOCK1793341572014', 'mock-pay', '2026-10-30 14:26:11', '2026-10-30 14:26:12', '2026-10-30 14:26:12', 0);
INSERT INTO `payment` VALUES (17, 'PAY17933416789301E4682D9', 28, 'ORD17933416786448081', 3, 280.00, 0, NULL, NULL, '2026-10-30 14:27:59', NULL, '2026-10-30 14:27:59', 0);
INSERT INTO `payment` VALUES (18, 'PAY179334310126187FB03F2', 29, 'BB17933430276436254', 3, 50.00, 1, 'MOCK1793343166443', 'mock-pay', '2026-10-30 14:51:41', '2026-10-30 14:52:46', '2026-10-30 14:51:41', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of refund_application
-- ----------------------------
INSERT INTO `refund_application` VALUES (1, 6, 'ORD17932410556052668', 3, 280.00, 'test refund batch2', NULL, NULL, NULL, NULL, 3, 'ok', 4, '2026-10-29 10:31:32', '2026-10-29 10:31:32', '2026-10-29 10:31:32', 0);
INSERT INTO `refund_application` VALUES (2, 7, 'ORD17932411228126411', 3, 560.00, 'reject test', NULL, NULL, NULL, NULL, 2, 'no', 4, '2026-10-29 10:32:03', '2026-10-29 10:32:03', '2026-10-29 10:32:03', 0);
INSERT INTO `refund_application` VALUES (3, 7, 'ORD17932411228126411', 3, 560.00, 're-apply test', NULL, NULL, NULL, NULL, 3, NULL, 4, '2026-10-29 10:32:04', '2026-10-29 10:32:03', '2026-10-29 10:32:03', 0);
INSERT INTO `refund_application` VALUES (4, 15, 'BB17932427057841153', 3, 50.00, 'box refund test', NULL, NULL, NULL, NULL, 3, 'box refund', 4, '2026-10-29 10:58:27', '2026-10-29 10:58:27', '2026-10-29 10:58:26', 0);
INSERT INTO `refund_application` VALUES (5, 22, 'ORD17933302459914498', 3, 280.00, 'regression after alipay refactor', NULL, NULL, NULL, NULL, 3, 'regression', 4, '2026-10-30 11:17:27', '2026-10-30 11:17:27', '2026-10-30 11:17:27', 0);
INSERT INTO `refund_application` VALUES (6, 26, 'ORD17933406567996926', 3, 280.00, 'postman refund test', NULL, NULL, NULL, NULL, 3, 'postman approve', 4, '2026-10-30 14:16:31', '2026-10-30 14:15:53', '2026-10-30 14:16:30', 0);
INSERT INTO `refund_application` VALUES (7, 27, 'ORD17933415707883417', 3, 280.00, 'post cleanup regression', NULL, NULL, NULL, NULL, 3, NULL, 4, '2026-10-30 14:26:12', '2026-10-30 14:26:12', '2026-10-30 14:26:12', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '购物车表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 3401032235 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '歌曲表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of song
-- ----------------------------
INSERT INTO `song` VALUES (1697604, 172195, 'Man In The Mirror', 'Michael Jackson', 320, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46');
INSERT INTO `song` VALUES (1697653, 172195, 'You Are Not Alone', 'Michael Jackson', 362, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46');
INSERT INTO `song` VALUES (1698397, 172259, 'The Girl Is Mine', 'Michael Jackson', 222, '/media/audio/1698397.mp3', NULL, 30, 1, '[00:00.000] 作曲 : Michael Jackson\n[00:12.080]Every night she walks right in my dreams\n[00:14.460]Since I met her from the start\n[00:17.160]I\'m so proud I am the only one\n[00:20.290]Who is special in her heart\n[00:22.640]The girl is mine\n[00:28.650]The doggone girl is mine\n[00:30.810]\n[00:35.420]I know she\'s mine\n[00:40.270]Because the doggone girl is mine\n[00:46.250]（Paul）\n[00:47.760]I don\'t understand the way you think\n[00:48.900]\n[00:50.360]Saying that she\'s yours not mine\n[00:52.380]Sending roses and your silly dreams\n[00:55.470]Really just a waste of time\n[00:58.920]Because she\'s mine\n[01:00.430]\n[01:04.100]The doggone girl is mine\n[01:06.620]\n[01:10.500]Don\'t waste your time\n[01:15.310]Because the doggone girl is mine\n[01:18.300]\n[01:22.200]I love you more than he\n[01:27.080]（Take you anywhere）\n[01:27.720]（Michael）\n[01:28.370]But I love you endlessly\n[01:30.300]（Loving we will share）\n[01:33.840]（Michael & Paul）\n[01:36.050]So come and go with me\n[01:37.750]Two on the town\n[01:40.370]（Michael）\n[01:40.540]But we both cannot have her\n[01:42.620]So it\'s one or the other\n[01:45.280]And one day you\'ll discover\n[01:48.020]That she\'s my girl forever and ever\n[01:52.150]（Paul）\n[01:52.960]Don\'t build your hopes to be let down\n[01:55.360]\'Cause I really feel it\'s time\n[01:57.240]（Michael）\n[01:58.330]I know she\'ll tell you I\'m the one for her\n[02:01.380]\'Cause she said I blow her mind\n[02:03.530]The girl is mine\n[02:08.410]The doggone girl is mine\n[02:15.550]Don\'t waste your time\n[02:20.180]Because the doggone girl is mine\n[02:22.250]（Michael & Paul）\n[02:23.980]She\'s mine she\'s mine\n[02:25.400]No no no she\'s mine\n[02:27.170]The girl is mine the girl is mine\n[02:30.450]The girl is mine the girl is mine\n[02:32.460]（Paul）\n[02:33.440]The girl is mine （yep） she\'s mine\n[02:35.560]The girl is mine （yes） she\'s mine\n[02:40.080]（Michael）\n[02:45.110]Don\'t waste your time\n[02:49.540]Because the doggone girl is mine\n[02:51.990]\n[02:56.840]The girl is mine the girl is mine\n[03:01.690]（Paul）\n[03:01.930]Michael we\'re not going to fight about this okay\n[03:04.470]（Michael）\n[03:04.690]Paul I think I told you I\'m a lover not a fighter\n[03:07.220]（Paul）\n[03:08.800]I\'ve heard it all before Michael she told me that I\'m her forever lover\n[03:12.470]You know don\'t you remember\n[03:14.490]（Michael）\n[03:14.850]Well after loving me she said she couldn\'t love another\n[03:16.850]（Paul）\n[03:17.550]Is that what she said\n[03:18.730]（Michael）\n[03:18.930]Yes she said it you keep dreaming\n[03:20.430]（Paul sings）\n[03:21.010]I don\'t believe it\n', 8, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46');
INSERT INTO `song` VALUES (1698413, 172259, 'Heal the World', 'Michael Jackson', 385, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46');
INSERT INTO `song` VALUES (21177810, 1958174, '(I Like) The Way You Love Me', 'Michael Jackson', 275, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46');
INSERT INTO `song` VALUES (21177813, 1958174, 'Best Of Joy', 'Michael Jackson', 183, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46');
INSERT INTO `song` VALUES (27505391, 2622323, 'Can You Feel It', 'The Jacksons', 357, NULL, NULL, 30, 103, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505392, 2622323, 'Don\'t Stop \'Til You Get Enough (Original Demo From 1978)', 'Michael Jackson', 288, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505393, 2622323, 'Don\'t Be Messin\' \'Round', 'Michael Jackson', 260, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505394, 2622323, 'This Is It', 'Michael Jackson', 220, NULL, NULL, 30, 59, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505395, 2622323, 'Ease on Down the Road', 'Michael Jackson', 200, NULL, NULL, 30, 34, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505396, 2622323, 'Workin\' Day and Night (Immortal Version)', 'Michael Jackson', 216, NULL, NULL, 30, 76, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505397, 2622323, 'Hold My Hand', 'Michael Jackson/Akon', 213, NULL, NULL, 30, 66, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505398, 2622323, 'Billie Jean (Home Demo From 1981)', 'Michael Jackson', 140, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505399, 2622323, 'You Can\'t Win', 'Michael Jackson', 438, NULL, NULL, 30, 35, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505400, 2622323, 'This Is It (Orchestra Version)', 'Michael Jackson', 295, NULL, NULL, 30, 60, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505401, 2622323, 'Billie Jean (Single Version)', 'Michael Jackson', 294, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505402, 2622323, 'Don\'t Stop \'Til You Get Enough (Live from the 1981 U.S. Tour)', 'The Jacksons', 263, NULL, NULL, 30, 104, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505403, 2622323, 'Workin\' Day and Night (Original Demo From 1978)', 'Michael Jackson', 260, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505404, 2622323, 'Hollywood Tonight', 'Michael Jackson', 271, NULL, NULL, 30, 67, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505405, 2622323, 'I\'m So Blue', 'Michael Jackson', 250, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-23 10:16:46', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505406, 2622323, 'The Immortal Intro (Immortal Version)', 'Michael Jackson/Jackson 5/Janet Jackson', 188, NULL, NULL, 30, 77, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505407, 2622323, 'Billie Jean (Long Version)', 'Michael Jackson', 383, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505408, 2622323, 'Don\'t Stop \'Till You Get Enough (Roger\'s Underground Solution Mix)', 'Michael Jackson', 380, NULL, NULL, 30, 105, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505409, 2622323, 'Keep Your Head Up', 'Michael Jackson', 292, NULL, NULL, 30, 68, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505410, 2622323, 'Song Groove (A/K/A Abortion Papers)', 'Michael Jackson', 267, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505411, 2622323, 'Childhood (Immortal Version)', 'Michael Jackson', 276, NULL, NULL, 30, 78, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505412, 2622323, 'Rock with You (Single Version)', 'Michael Jackson', 203, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505413, 2622323, 'She\'s out of My Life (Demo)', 'Michael Jackson', 199, NULL, NULL, 30, 61, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505414, 2622323, 'Shake a Body (Early Demo)', 'The Jacksons', 128, NULL, NULL, 30, 36, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505415, 2622323, 'Billie Jean (Underground Mix)', 'Michael Jackson', 400, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505416, 2622323, '(I Like) The Way You Love Me', 'Michael Jackson', 275, NULL, NULL, 30, 69, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505417, 2622323, 'Free', 'Michael Jackson', 265, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505418, 2622323, 'Shake Your Body (Down to the Ground) [Single Edit]', 'The Jacksons', 228, NULL, NULL, 30, 37, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505419, 2622323, 'Rock with You (Frankie Knuckles Radio Mix)', 'Michael Jackson', 229, NULL, NULL, 30, 106, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505420, 2622323, 'Off the Wall', 'Michael Jackson', 228, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505421, 2622323, 'Wanna Be Startin\' Somethin\' (Immortal Version)', 'Michael Jackson', 188, NULL, NULL, 30, 79, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505422, 2622323, 'Beat It (Demo)', 'Michael Jackson', 124, NULL, NULL, 30, 62, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505423, 2622323, 'Rock with You (Frankie\'s Favorite Club Mix)', 'Michael Jackson', 457, NULL, NULL, 30, 107, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505424, 2622323, 'Wanna Be Startin\' Somethin\' (Demo)', 'Michael Jackson', 343, NULL, NULL, 30, 63, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505425, 2622323, 'Monster', 'Michael Jackson/50 Cent', 306, NULL, NULL, 30, 70, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505426, 2622323, 'Price of Fame', 'Michael Jackson', 274, NULL, NULL, 30, 24, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505427, 2622323, 'Beat It (Single Version)', 'Michael Jackson', 258, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505428, 2622323, 'P.Y.T. (Pretty Young Thing) [Demo Version]', 'Michael Jackson', 227, NULL, NULL, 30, 38, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505429, 2622323, 'She\'s out of My Life (Single Version)', 'Michael Jackson', 219, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505430, 2622323, 'Shake Your Body (Down to the Ground) [Immortal Version]', 'The Jacksons', 150, NULL, NULL, 30, 80, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505431, 2622323, 'Rock with You (Masters at Work Remix)', 'Michael Jackson', 331, NULL, NULL, 30, 108, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505432, 2622323, 'Sunset Driver (Demo)', 'Michael Jackson', 243, NULL, NULL, 30, 39, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505433, 2622323, 'Smooth Criminal (Radio Edit)', 'Michael Jackson', 258, NULL, NULL, 30, 64, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505434, 2622323, 'Dancing Machine / Blame It on the Boogie (Immortal Version)', 'Michael Jackson/The Jacksons/Jackson 5', 247, NULL, NULL, 30, 81, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505435, 2622323, 'Beat It Thriller (25th Anniversary Remix)', 'Michael Jackson/Fergie', 252, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505436, 2622323, 'Al Capone', 'Michael Jackson', 215, NULL, NULL, 30, 25, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505437, 2622323, 'Best of Joy', 'Michael Jackson', 183, NULL, NULL, 30, 71, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505438, 2622323, 'Streetwalker', 'Michael Jackson', 349, NULL, NULL, 30, 26, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505439, 2622323, 'Scared of the Moon (Demo)', 'Michael Jackson', 282, NULL, NULL, 30, 40, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505440, 2622323, 'Rock with You (Live)', 'The Jacksons', 238, NULL, NULL, 30, 109, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505441, 2622323, 'Breaking News', 'Michael Jackson', 255, NULL, NULL, 30, 72, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505442, 2622323, 'Ben (Immortal Version)', 'Michael Jackson', 226, NULL, NULL, 30, 82, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505443, 2622323, 'Planet Earth (Poem)', 'Michael Jackson', 195, NULL, NULL, 30, 65, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505444, 2622323, 'The Girl Is Mine (Thriller 25th Anniversary Remix)', 'Michael Jackson/will.i.am', 192, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505445, 2622323, 'State of Shock', 'The Jacksons', 270, NULL, NULL, 30, 41, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505446, 2622323, 'P.Y.T. (Pretty Young Thing) [Thriller 25th Anniversary Remix]', 'Michael Jackson/will.i.am', 261, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505447, 2622323, 'Off the Wall (Live)', 'The Jacksons', 242, NULL, NULL, 30, 110, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505448, 2622323, '(I Can\'t Make It) Another Day', 'Michael Jackson/Lenny Kravitz', 234, NULL, NULL, 30, 73, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505449, 2622323, 'Fly Away', 'Michael Jackson', 207, NULL, NULL, 30, 27, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505450, 2622323, 'This Place Hotel (Immortal Version)', 'Michael Jackson', 129, NULL, NULL, 30, 83, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505451, 2622323, 'We Are the World (Demo)', 'Michael Jackson', 321, NULL, NULL, 30, 42, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505452, 2622323, 'Behind the Mask', 'Michael Jackson', 303, NULL, NULL, 30, 74, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505453, 2622323, 'I Just Can\'t Stop Loving You', 'Michael Jackson/Siedah Garrett', 266, NULL, NULL, 30, 28, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505454, 2622323, 'She\'s Out of My Life (Live)', 'The Jacksons', 287, NULL, NULL, 30, 111, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505455, 2622323, 'Wanna Be Startin\' Somethin\' (Thriller 25th Anniversary Remix)', 'Michael Jackson/Akon', 254, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505456, 2622323, 'Smooth Criminal (Immortal Version)', 'Michael Jackson', 120, NULL, NULL, 30, 84, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505457, 2622323, 'Working Day and Night (Live)', 'The Jacksons', 414, NULL, NULL, 30, 112, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505458, 2622323, 'For All Time', 'Michael Jackson', 244, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505459, 2622323, 'Todo Mi Amor Eres Tu (I Just Can\'t Stop Loving You)', 'Michael Jackson', 251, NULL, NULL, 30, 29, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505460, 2622323, 'We Are Here to Change the World', 'Michael Jackson', 171, NULL, NULL, 30, 43, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505461, 2622323, 'Much Too Soon', 'Michael Jackson', 169, NULL, NULL, 30, 75, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505462, 2622323, 'Dangerous (Immortal Version)', 'Michael Jackson', 162, NULL, NULL, 30, 85, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505463, 2622323, 'Cheater (Demo)', 'Michael Jackson', 310, NULL, NULL, 30, 44, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505464, 2622323, 'Got the Hots (Thriller 25th Anniversary)', 'Michael Jackson', 268, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505465, 2622323, 'Can\'t Get Outta the Rain', 'Michael Jackson', 245, NULL, NULL, 30, 113, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505466, 2622323, 'Je Ne Veux Pas La Fin De Nous (I Just Can\'t Stop Loving You) [French Version]', 'Michael Jackson', 248, NULL, NULL, 30, 30, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505467, 2622323, 'The Mime Segment: (I Like) The Way You Love Me / Speed Demon / Another Part of Me [Immortal Version]', 'Michael Jackson', 173, NULL, NULL, 30, 86, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505468, 2622323, 'Monkey Business', 'Michael Jackson', 346, NULL, NULL, 30, 45, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505469, 2622323, 'Someone in the Dark', 'Michael Jackson', 289, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505470, 2622323, 'Bad (Remix By Afrojack Featuring Pitbull - DJ Buddha Edit)', 'Michael Jackson/Pitbull', 267, NULL, NULL, 30, 31, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505471, 2622323, 'Say Say Say', 'Michael Jackson/Paul McCartney', 235, NULL, NULL, 30, 114, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505472, 2622323, 'The Jackson 5 Medley (Immortal Version)', 'Jackson 5', 226, NULL, NULL, 30, 87, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505473, 2622323, 'Dangerous (Early Version)', 'Michael Jackson', 401, NULL, NULL, 30, 46, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505474, 2622323, 'Beat It (Moby\'s Sub Mix)', 'Michael Jackson', 371, NULL, NULL, 30, 115, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505475, 2622323, 'Speed Demon (Remix by Nero)', 'Michael Jackson', 250, NULL, NULL, 30, 32, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505476, 2622323, 'Speechless/Human Nature (Immortal Version)', 'Michael Jackson', 199, NULL, NULL, 30, 88, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505477, 2622323, 'Carousel', 'Michael Jackson', 220, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505478, 2622323, 'Who Is It (IHS Mix)', 'Michael Jackson', 478, NULL, NULL, 30, 47, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505479, 2622323, 'Wanna Be Startin\' Somethin\' (Brothers In Rhythm House Mix)', 'Michael Jackson', 455, NULL, NULL, 30, 116, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505480, 2622323, 'Bad (Remix by Afrojack) [Club Mix]', 'Michael Jackson', 456, NULL, NULL, 30, 33, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505481, 2622323, 'Thriller (Instrumental)', 'Michael Jackson', 358, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505482, 2622323, 'Is It Scary/Threatened (Immortal Version) [feat. 50 Cent]', 'Michael Jackson/Rockwell/50 Cent', 304, NULL, NULL, 30, 89, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505483, 2622323, 'Someone Put Your Hand Out', 'Michael Jackson', 326, NULL, NULL, 30, 48, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505484, 2622323, 'Wanna Be Startin\' Somethin\' (Instrumental)', 'Michael Jackson', 257, NULL, NULL, 30, 117, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505485, 2622323, 'Thriller (Immortal Version)', 'Michael Jackson', 218, NULL, NULL, 30, 90, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505486, 2622323, 'Thriller Megamix', 'Michael Jackson', 553, NULL, NULL, 30, 118, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505487, 2622323, 'You Are Not Alone/I Just Can\'t Stop Loving You (Immortal Version)', 'Michael Jackson/Siedah Garrett', 368, NULL, NULL, 30, 91, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505488, 2622323, 'On the Line', 'Michael Jackson', 294, NULL, NULL, 30, 49, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505489, 2622323, 'Bad (Dance Extended Mix)', 'Michael Jackson', 505, NULL, NULL, 30, 119, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505490, 2622323, 'Fall Again (Demo)', 'Michael Jackson', 263, NULL, NULL, 30, 50, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505491, 2622323, 'Beat It / State of Shock (Immortal Version)', 'Michael Jackson/Mick Jagger', 189, NULL, NULL, 30, 92, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505492, 2622323, 'The Way You Make Me Feel (Dance Extended Mix)', 'Michael Jackson', 473, NULL, NULL, 30, 120, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505493, 2622323, 'In the Back', 'Michael Jackson', 272, NULL, NULL, 30, 51, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505494, 2622323, 'Jam (Immortal Version)', 'Michael Jackson', 158, NULL, NULL, 30, 93, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505495, 2622323, 'The Way You Make Me Feel (Instrumental)', 'Michael Jackson', 265, NULL, NULL, 30, 121, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505496, 2622323, 'Planet Earth/Earth Song (Immortal Version)', 'Michael Jackson', 244, NULL, NULL, 30, 94, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505497, 2622323, 'Beautiful Girl (Demo)', 'Michael Jackson', 243, NULL, NULL, 30, 52, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505498, 2622323, 'Man in the Mirror (Instrumental)', 'Michael Jackson', 305, NULL, NULL, 30, 122, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505499, 2622323, 'The Way You Love Me', 'Michael Jackson', 271, NULL, NULL, 30, 53, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505500, 2622323, 'Scream/Little Susie (Immortal Version)', 'Michael Jackson/Janet Jackson', 285, NULL, NULL, 30, 95, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505501, 2622323, 'We\'ve Had Enough', 'Michael Jackson', 345, NULL, NULL, 30, 54, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505502, 2622323, 'Dirty Diana (Instrumental)', 'Michael Jackson', 281, NULL, NULL, 30, 123, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505503, 2622323, 'Gone Too Soon (Immortal Version)', 'Michael Jackson', 204, NULL, NULL, 30, 96, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505504, 2622323, 'Another Part of Me (Extended Dance Mix)', 'Michael Jackson', 381, NULL, NULL, 30, 124, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505505, 2622323, 'You Rock My World (with intro)', 'Michael Jackson', 306, NULL, NULL, 30, 55, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505506, 2622323, 'They Don\'t Care About Us (Immortal Version)', 'Michael Jackson', 217, NULL, NULL, 30, 97, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505507, 2622323, 'Will You Be There (Immortal Version)', 'Michael Jackson', 299, NULL, NULL, 30, 98, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505508, 2622323, 'Another Part of Me (Instrumental)', 'Michael Jackson', 226, NULL, NULL, 30, 125, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505509, 2622323, 'Enjoy Yourself', 'The Jacksons', 220, NULL, NULL, 30, 56, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505510, 2622323, 'Smooth Criminal (Dance Radio Edit)', 'Michael Jackson', 324, NULL, NULL, 30, 126, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505511, 2622323, 'Lovely One', 'The Jacksons', 292, NULL, NULL, 30, 57, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505512, 2622323, 'I\'ll Be There (Immortal Version)', 'Jackson 5', 110, NULL, NULL, 30, 99, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505513, 2622323, 'Immortal Megamix: Can You Feel It/Don\'t Stop \'Til You Get Enough/Billie Jean/Black or White (Immorta', 'Michael Jackson/The Jacksons', 549, NULL, NULL, 30, 100, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505514, 2622323, 'Smooth Criminal (Ext Dance Mix)', 'Michael Jackson', 468, NULL, NULL, 30, 127, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505515, 2622323, 'This Place Hotel (A/k/A Heartbreak Hotel)', 'The Jacksons', 342, NULL, NULL, 30, 58, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505516, 2622323, 'Smooth Criminal (Instrumental)', 'Michael Jackson', 251, NULL, NULL, 30, 128, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505517, 2622323, 'Man in the Mirror (Immortal Version)', 'Michael Jackson', 258, NULL, NULL, 30, 101, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505518, 2622323, 'Remember the Time / Bad (Immortal Version)', 'Michael Jackson', 278, NULL, NULL, 30, 102, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505519, 2622323, 'Liberian Girl (UK Edit)', 'Michael Jackson', 220, NULL, NULL, 30, 129, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505520, 2622323, 'Black or White (The Clivilles & Cole Radio Mix)', 'Michael Jackson', 214, NULL, NULL, 30, 130, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505521, 2622323, 'Black or White (The Clivilles & Cole House/Club Mix)', 'Michael Jackson', 453, NULL, NULL, 30, 131, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505522, 2622323, 'Black or White (House With Guitar Radio Mix)', 'Michael Jackson', 230, NULL, NULL, 30, 132, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505523, 2622323, 'Black or White (The Underground Club Mix)', 'Michael Jackson', 447, NULL, NULL, 30, 133, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505524, 2622323, 'Black or White (Instrumental)', 'Michael Jackson', 201, NULL, NULL, 30, 134, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505525, 2622323, 'Remember the Time (New Jack Radio Mix)', 'Michael Jackson', 240, NULL, NULL, 30, 135, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505526, 2622323, 'Remember the Time (Silky Soul 7)', 'Michael Jackson', 263, NULL, NULL, 30, 136, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505527, 2622323, 'Remember the Time (12\" Main Mix)', 'Michael Jackson', 287, NULL, NULL, 30, 137, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505528, 2622323, 'Remember the Time (Maurice\'s Underground)', 'Michael Jackson', 450, NULL, NULL, 30, 138, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505529, 2622323, 'Remember the Time (E-Smoove\'s Late Nite Mix)', 'Michael Jackson', 440, NULL, NULL, 30, 139, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505530, 2622323, 'In the Closet (Radio Edit)', 'Michael Jackson', 275, NULL, NULL, 30, 140, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505531, 2622323, 'In the Closet (7\" Edit)', 'Michael Jackson', 288, NULL, NULL, 30, 141, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505532, 2622323, 'Jam (Silky 12\" Mix)', 'Michael Jackson', 386, NULL, NULL, 30, 142, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505533, 2622323, 'Dangerous (Roger\'s Dangerous Edit)', 'Michael Jackson', 279, NULL, NULL, 30, 143, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505534, 2622323, 'Who Is It (Brothers in Rhythm House Mix)', 'Michael Jackson', 478, NULL, NULL, 30, 144, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505535, 2622323, 'Will You Be There (Instrumental)', 'Michael Jackson', 219, NULL, NULL, 30, 145, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505536, 2622323, 'Gone Too Soon (Instrumental)', 'Michael Jackson', 202, NULL, NULL, 30, 146, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505537, 2622323, 'Scream Louder (Flyte Tyme Remix)', 'Michael Jackson/Janet Jackson', 327, NULL, NULL, 30, 147, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505538, 2622323, 'Scream (Classic Club Mix)', 'Michael Jackson', 543, NULL, NULL, 30, 148, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505539, 2622323, 'Earth Song (Radio Edit)', 'Michael Jackson', 302, NULL, NULL, 30, 149, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505540, 2622323, 'Earth Song (Hani\'s Extended Radio Experience)', 'Michael Jackson', 475, NULL, NULL, 30, 150, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505541, 2622323, 'They Don\'t Care About Us (Love To Infinity\'s Walk In The Park Mix)', 'Michael Jackson', 439, NULL, NULL, 30, 151, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505542, 2622323, 'Stranger in Moscow (Tee\'s Radio Mix)', 'Michael Jackson', 263, NULL, NULL, 30, 152, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505543, 2622323, 'Smile (Short Version)', 'Michael Jackson', 250, NULL, NULL, 30, 153, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505544, 2622323, 'Is It Scary (Radio Edit)', 'Michael Jackson', 252, NULL, NULL, 30, 154, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505545, 2622323, 'Is It Scary (Deep Dish Dark And Scary Radio Edit)', 'Michael Jackson', 281, NULL, NULL, 30, 155, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505546, 2622323, 'Shout', 'Michael Jackson', 256, NULL, NULL, 30, 156, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505547, 2622323, 'One More Chance', 'Michael Jackson', 229, NULL, NULL, 30, 157, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505548, 2622323, 'One More Chance (Metro Remix)', 'Michael Jackson', 224, NULL, NULL, 30, 158, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505549, 2622323, 'One More Chance (Paul Oakenfold Mix)', 'Michael Jackson', 232, NULL, NULL, 30, 159, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505550, 2622323, 'One More Chance (Paul Oakenfold Urban Mix)', 'Michael Jackson', 212, NULL, NULL, 30, 160, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505551, 2622323, 'One More Chance (Ron G Club Remix)', 'Michael Jackson', 233, NULL, NULL, 30, 161, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27505552, 2622323, 'Michael Jackson DMC Megamix', 'Michael Jackson', 677, NULL, NULL, 30, 162, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536379, 2627713, 'Don\'t Stop \'Til You Get Enough (Single Version)', 'Michael Jackson', 357, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536380, 2627713, 'Wanna Be Startin\' Somethin\'', 'Michael Jackson', 363, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536381, 2627713, 'Bad (Remastered)', 'Michael Jackson', 247, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536382, 2627713, 'Jam', 'Michael Jackson/Heavy D', 341, NULL, NULL, 30, 31, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536383, 2627713, 'Scream', 'Michael Jackson/Janet Jackson', 280, NULL, NULL, 30, 45, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536384, 2627713, 'Blood on the Dance Floor', 'Michael Jackson', 253, NULL, NULL, 30, 60, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536385, 2627713, 'Unbreakable', 'Michael Jackson/The Notorious B.I.G.', 387, NULL, NULL, 30, 72, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536386, 2627713, 'Wanna Be Startin\' Somethin\' (Live At Wembley July 16, 1988)', 'Michael Jackson', 321, NULL, NULL, 30, 88, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536387, 2627713, 'Rock with You (Single Version)', 'Michael Jackson', 220, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536388, 2627713, 'Baby Be Mine', 'Michael Jackson', 261, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536389, 2627713, 'The Way You Make Me Feel (Remastered)', 'Michael Jackson', 298, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536390, 2627713, 'Why You Wanna Trip on Me', 'Michael Jackson', 325, NULL, NULL, 30, 32, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536391, 2627713, 'They Don\'t Care About Us', 'Michael Jackson', 284, NULL, NULL, 30, 46, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536393, 2627713, 'Heartbreaker', 'Michael Jackson', 311, NULL, NULL, 30, 73, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536394, 2627713, 'This Place Hotel (Live At Wembley July 16, 1988)', 'Michael Jackson', 294, NULL, NULL, 30, 89, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536395, 2627713, 'Workin\' Day and Night', 'Michael Jackson', 314, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536396, 2627713, 'The Girl Is Mine', 'Michael Jackson/Paul McCartney', 223, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536397, 2627713, 'Speed Demon (Remastered)', 'Michael Jackson', 241, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536398, 2627713, 'In the Closet', 'Michael Jackson', 391, NULL, NULL, 30, 33, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536399, 2627713, 'Stranger in Moscow', 'Michael Jackson', 344, NULL, NULL, 30, 47, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536400, 2627713, 'Superfly Sister', 'Michael Jackson', 388, NULL, NULL, 30, 61, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536401, 2627713, 'Invincible', 'Michael Jackson', 286, NULL, NULL, 30, 74, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536402, 2627713, 'Another Part of Me (Live At Wembley July 16, 1988)', 'Michael Jackson', 242, NULL, NULL, 30, 90, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536403, 2627713, 'Get on the Floor', 'Michael Jackson', 278, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536404, 2627713, 'Thriller', 'Michael Jackson', 358, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536405, 2627713, 'Liberian Girl (Remastered)', 'Michael Jackson', 233, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536406, 2627713, 'She Drives Me Wild', 'Michael Jackson', 222, NULL, NULL, 30, 34, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536407, 2627713, 'This Time Around', 'Michael Jackson', 261, NULL, NULL, 30, 48, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536408, 2627713, 'Ghost', 'Michael Jackson', 314, NULL, NULL, 30, 62, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536409, 2627713, 'Break of Dawn', 'Michael Jackson', 332, NULL, NULL, 30, 75, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536410, 2627713, 'I Just Can\'t Stop Loving You (Live At Wembley July 16, 1988)', 'Michael Jackson', 264, NULL, NULL, 30, 91, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536411, 2627713, 'Off the Wall', 'Michael Jackson', 246, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536412, 2627713, 'Beat It (Single Version)', 'Michael Jackson', 258, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536413, 2627713, 'Just Good Friends (Remastered)', 'Michael Jackson', 247, NULL, NULL, 30, 24, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536414, 2627713, 'Remember the Time', 'Michael Jackson', 240, NULL, NULL, 30, 35, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536415, 2627713, 'Earth Song', 'Michael Jackson', 406, NULL, NULL, 30, 49, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536416, 2627713, 'Is It Scary', 'Michael Jackson', 336, NULL, NULL, 30, 63, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536417, 2627713, 'Heaven Can Wait', 'Michael Jackson', 290, NULL, NULL, 30, 76, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536418, 2627713, 'She\'s Out of My Life (Live At Wembley July 16, 1988)', 'Michael Jackson', 196, NULL, NULL, 30, 92, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536419, 2627713, 'Girlfriend', 'Michael Jackson', 185, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536420, 2627713, 'Billie Jean (Single Version)', 'Michael Jackson', 295, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536421, 2627713, 'Another Part of Me (Remastered)', 'Michael Jackson', 235, NULL, NULL, 30, 25, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536422, 2627713, 'Can\'t Let Her Get Away', 'Michael Jackson', 302, NULL, NULL, 30, 36, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536423, 2627713, 'D.S.', 'Michael Jackson', 290, NULL, NULL, 30, 50, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536424, 2627713, 'Scream Louder (Flyte Tyme Remix)', 'Michael Jackson/Janet Jackson', 327, NULL, NULL, 30, 64, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536425, 2627713, 'You Rock My World (With Intro)', 'Michael Jackson', 339, NULL, NULL, 30, 77, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536426, 2627713, 'I Want You Back / The Love You Save / I\'ll Be There (Live At Wembley July 16, 1988)', 'Michael Jackson', 306, NULL, NULL, 30, 93, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536427, 2627713, 'She\'s out of My Life (Single Version)', 'Michael Jackson', 218, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536428, 2627713, 'Human Nature', 'Michael Jackson', 246, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536429, 2627713, 'Man in the Mirror (Remastered)', 'Michael Jackson', 320, NULL, NULL, 30, 26, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536430, 2627713, 'Heal the World', 'Michael Jackson', 384, NULL, NULL, 30, 37, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536431, 2627713, 'Money', 'Michael Jackson', 282, NULL, NULL, 30, 51, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536432, 2627713, 'Money (Fire Island Radio Edit)', 'Michael Jackson', 262, NULL, NULL, 30, 65, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536433, 2627713, 'Butterflies', 'Michael Jackson', 280, NULL, NULL, 30, 78, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536434, 2627713, 'Rock with You (Live At Wembley July 16, 1988)', 'Michael Jackson', 245, NULL, NULL, 30, 94, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536435, 2627713, 'I Can\'t Help It', 'Michael Jackson', 269, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536436, 2627713, 'P.Y.T. (Pretty Young Thing)', 'Michael Jackson', 239, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536437, 2627713, 'I Just Can\'t Stop Loving You [Remastered]', 'Michael Jackson/Siedah Garrett', 254, NULL, NULL, 30, 27, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536438, 2627713, 'Black or White', 'Michael Jackson', 203, NULL, NULL, 30, 38, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536439, 2627713, 'Come Together', 'Michael Jackson', 242, NULL, NULL, 30, 52, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536440, 2627713, '2 Bad (Refugee Camp Mix)', 'Michael Jackson', 214, NULL, NULL, 30, 66, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536441, 2627713, 'Speechless', 'Michael Jackson', 199, NULL, NULL, 30, 79, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536442, 2627713, 'Human Nature (Live At Wembley July 16, 1988)', 'Michael Jackson', 269, NULL, NULL, 30, 95, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536443, 2627713, 'It\'s the Falling in Love', 'Michael Jackson', 228, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536444, 2627713, 'The Lady in My Life', 'Michael Jackson', 298, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536445, 2627713, 'Dirty Diana (Remastered)', 'Michael Jackson', 281, NULL, NULL, 30, 28, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536446, 2627713, 'Who Is It', 'Michael Jackson', 395, NULL, NULL, 30, 39, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536447, 2627713, 'You Are Not Alone', 'Michael Jackson', 345, NULL, NULL, 30, 53, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536448, 2627713, 'Stranger in Moscow (Tee\'s In-House Club Mix)', 'Michael Jackson', 414, NULL, NULL, 30, 67, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536449, 2627713, '2000 Watts', 'Michael Jackson', 265, NULL, NULL, 30, 80, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536450, 2627713, 'Smooth Criminal (Live At Wembley July 16, 1988)', 'Michael Jackson', 281, NULL, NULL, 30, 96, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536451, 2627713, 'Burn This Disco Out', 'Michael Jackson', 224, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536452, 2627713, 'Smooth Criminal (Remastered)', 'Michael Jackson', 260, NULL, NULL, 30, 29, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536453, 2627713, 'Give in to Me', 'Michael Jackson', 329, NULL, NULL, 30, 40, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536454, 2627713, 'Childhood (Theme from \"Free Willy 2\")', 'Michael Jackson', 268, NULL, NULL, 30, 54, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536455, 2627713, 'This Time Around (D.M. Radio Mix)', 'Michael Jackson', 245, NULL, NULL, 30, 68, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536456, 2627713, 'You Are My Life', 'Michael Jackson', 274, NULL, NULL, 30, 81, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536457, 2627713, 'Dirty Diana (Live At Wembley July 16, 1988)', 'Michael Jackson', 301, NULL, NULL, 30, 97, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536458, 2627713, 'Leave Me Alone (Remastered)', 'Michael Jackson', 280, NULL, NULL, 30, 30, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536459, 2627713, 'Will You Be There', 'Michael Jackson/The Cleveland Orchestra', 460, NULL, NULL, 30, 41, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536460, 2627713, 'Tabloid Junkie', 'Michael Jackson', 273, NULL, NULL, 30, 55, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536461, 2627713, 'Earth Song (Hani\'s Extended Radio Experience)', 'Michael Jackson', 475, NULL, NULL, 30, 69, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536462, 2627713, 'Privacy', 'Michael Jackson', 305, NULL, NULL, 30, 82, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536463, 2627713, 'Thriller (Live At Wembley July 16, 1988)', 'Michael Jackson', 268, NULL, NULL, 30, 98, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536464, 2627713, 'Keep the Faith', 'Michael Jackson', 358, NULL, NULL, 30, 42, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536465, 2627713, '2 Bad', 'Michael Jackson', 290, NULL, NULL, 30, 56, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536466, 2627713, 'You Are Not Alone (Classic Club Mix)', 'Michael Jackson', 457, NULL, NULL, 30, 70, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536467, 2627713, 'Don\'t Walk Away', 'Michael Jackson', 265, NULL, NULL, 30, 83, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536468, 2627713, 'Working Day and Night (Live At Wembley July 16, 1988)', 'Michael Jackson', 354, NULL, NULL, 30, 99, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536469, 2627713, 'Gone Too Soon', 'Michael Jackson', 202, NULL, NULL, 30, 43, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536470, 2627713, 'History', 'Michael Jackson', 398, NULL, NULL, 30, 57, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536471, 2627713, 'History (Tony Moran\'s HIStory Lesson)', 'Michael Jackson', 481, NULL, NULL, 30, 71, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536472, 2627713, 'Cry', 'Michael Jackson', 301, NULL, NULL, 30, 84, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536473, 2627713, 'Beat It (Live At Wembley July 16, 1988)', 'Michael Jackson', 345, NULL, NULL, 30, 100, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536474, 2627713, 'Dangerous', 'Michael Jackson', 420, NULL, NULL, 30, 44, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536475, 2627713, 'Little Susie / Pie Jesu', 'Michael Jackson', 374, NULL, NULL, 30, 58, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536476, 2627713, 'The Lost Children', 'Michael Jackson', 241, NULL, NULL, 30, 85, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536477, 2627713, 'Billie Jean (Live At Wembley July 16, 1988)', 'Michael Jackson', 339, NULL, NULL, 30, 101, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536478, 2627713, 'Smile', 'Michael Jackson', 296, NULL, NULL, 30, 59, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536479, 2627713, 'Whatever Happens', 'Michael Jackson', 297, NULL, NULL, 30, 86, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536480, 2627713, 'Bad (Live At Wembley July 16, 1988)', 'Michael Jackson', 268, NULL, NULL, 30, 102, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536481, 2627713, 'Threatened', 'Michael Jackson', 261, NULL, NULL, 30, 87, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (27536482, 2627713, 'Man in the Mirror (Live At Wembley July 16, 1988)', 'Michael Jackson', 382, NULL, NULL, 30, 103, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524016, 2805307, 'Love Never Felt So Good', 'Michael Jackson', 235, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46');
INSERT INTO `song` VALUES (28524017, 2805307, 'Chicago', 'Michael Jackson', 245, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524018, 2805307, 'Loving You', 'Michael Jackson', 195, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-23 10:16:46', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524019, 2805307, 'A Place With No Name', 'Michael Jackson', 335, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524020, 2805307, 'Slave to the Rhythm', 'Michael Jackson', 255, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524021, 2805307, 'Do You Know Where Your Children Are', 'Michael Jackson', 276, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524022, 2805307, 'Blue Gangsta', 'Michael Jackson', 254, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524023, 2805307, 'Xscape', 'Michael Jackson', 245, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524024, 2805307, 'Love Never Felt So Good (Original Version)', 'Michael Jackson', 201, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524025, 2805307, 'Chicago (Original Version)', 'Michael Jackson', 283, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524026, 2805307, 'Loving You (Original Version)', 'Michael Jackson', 182, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524027, 2805307, 'A Place With No Name (Original Version)', 'Michael Jackson', 296, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524028, 2805307, 'Slave to the Rhythm (Original Version)', 'Michael Jackson', 276, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524029, 2805307, 'Do You Know Where Your Children Are (Original Version)', 'Michael Jackson', 279, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524030, 2805307, 'Blue Gangsta (Original Version)', 'Michael Jackson', 257, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524031, 2805307, 'Xscape (Original Version)', 'Michael Jackson', 344, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28524032, 2805307, 'Love Never Felt So Good', 'Michael Jackson/Justin Timberlake', 246, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28547423, 2835047, 'Love Never Felt So Good (Fedde Le Grand Remix Radio Edit)', 'Michael Jackson', 206, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28786569, 2894086, 'Love Never Felt So Good (DM-FK Classic Tribute Mix)', 'Michael Jackson', 504, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28786570, 2894086, 'Love Never Felt So Good (DM Classic Radio Mix)', 'Michael Jackson', 251, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28786571, 2894086, 'Love Never Felt So Good (DM Epic Dub Mix)', 'Michael Jackson', 474, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28786572, 2894086, 'Love Never Felt So Good (DM Red Zone Mix)', 'Michael Jackson', 412, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (28863100, 2915337, 'Slave To The Rhythm (Audien Remix)', 'Michael Jackson', 249, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (29558555, 3042654, 'PYT (Reflex Revision)', 'Reflex/Michael Jackson', 423, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (29558556, 3042654, 'Get Kon the Floor', 'kon/Michael Jackson', 609, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757294, 34522208, 'Wanna Be Startin\' Somethin\'', 'Michael Jackson', 362, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757295, 34522208, 'Baby Be Mine', 'Michael Jackson/R. Temperton', 260, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757296, 34522208, 'The Girl Is Mine', 'Michael Jackson', 222, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757297, 34522208, 'Thriller', 'Michael Jackson', 358, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757298, 34522208, 'Beat It', 'Michael Jackson', 258, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757299, 34522208, 'Billie Jean', 'Michael Jackson', 293, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757300, 34522208, 'Human Nature', 'Steve Porcaro/Michael Jackson', 246, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757301, 34522208, 'P.Y.T. (Pretty Young Thing)', 'James Ingram/Quincy Jones/Michael Jackson', 239, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757302, 34522208, 'The Lady in My Life', 'Michael Jackson/R. Temperton', 298, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757303, 34522208, 'Vincent Price Excerpt From \"Thriller\" Voice-Over Session (Thriller 25th Anniversary Voice-Over Sessi', 'Vincent Price', 23, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757304, 34522208, 'The Girl Is Mine 2008 with will.i.am (Thriller 25th Anniversary Remix)', 'Michael Jackson/will.i.am', 190, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757305, 34522208, 'P.Y.T. (Pretty Young Thing) 2008 with will.i.am (Thriller 25th Anniversary Remix feat. willi.i.am)', 'Michael Jackson/will.i.am', 261, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757306, 34522208, 'Wanna Be Startin\' Somethin\' 2008 with Akon (Thriller 25th Anniversary Remix)', 'Michael Jackson/Akon', 254, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757307, 34522208, 'Beat It 2008 (Thriller 25th Anniversary Remix feat. Fergie)', 'Michael Jackson/Fergie', 251, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757308, 34522208, 'Billie Jean 2008 Kanye West Mix (Thriller 25th Anniversary Remix)', 'Michael Jackson/Kanye West', 276, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757309, 34522208, 'For All Time', 'Steve Porcaro/Michael Jackson/Michael Sherwood', 244, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757310, 34522208, 'Voice-Over Intro Quincy Jones Interview #1 / Quincy Jones Interview #1', 'Quincy Jones', 138, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757311, 34522208, 'Someone in the Dark', 'Michael Jackson/A. Bergman/M. Bergman/R. Temperton', 288, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757312, 34522208, 'Voice-Over Intro Quincy Jones Interview #2/Quincy Jones Interview #2 / Voice-Over Intro Billie Jean ', 'Quincy Jones', 124, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757313, 34522208, 'Billie Jean (Home Demo from 1981)', 'Michael Jackson', 140, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757314, 34522208, 'Quincy Jones Interview #3', 'Quincy Jones/Spoken Word', 190, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757315, 34522208, 'Voice-Over Intro Rod Temperton Interview #1 / Rod Temperton Interview #1', 'Rod Temperton', 243, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757316, 34522208, 'Quincy Jones Interview #4', 'Quincy Jones/Spoken Word', 93, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757317, 34522208, 'Voice-Over Intro / Voice-Over Session from Thriller', 'Vincent Price/Spoken Word/Michael Jackson', 172, NULL, NULL, 30, 24, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757318, 34522208, 'Voice-Over Intro Rod Temperton Interview #2 / Rod Temperton Interview #2', 'Spoken Word', 116, NULL, NULL, 30, 25, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757319, 34522208, 'Quincy Jones Interview #5', 'Quincy Jones', 122, NULL, NULL, 30, 26, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757320, 34522208, 'Carousel', 'Michael Jackson/D. Freeman/M. Sembello', 109, NULL, NULL, 30, 27, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757321, 34522208, 'Voice-Over Intro Quincy Jones Interview #6 / Quincy Jones Interview #6', 'Quincy Jones/Spoken Word', 78, NULL, NULL, 30, 28, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757322, 34522208, 'Billie Jean (Underground Mix)', 'Michael Jackson', 400, NULL, NULL, 30, 29, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (404757323, 34522208, 'Thriller (Instrumental)', 'Michael Jackson/ROD TEMPERTON', 358, NULL, NULL, 30, 30, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (436045129, 2835047, 'Love Never Felt So Good (DM CLASSIC RADIO MIX)', 'Michael Jackson', 251, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (436045130, 2835047, 'Love Never Felt so Good', 'Michael Jackson', 246, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (436045131, 2835047, 'Love Never Felt So Good (DM EPIC DUB MIX)', 'Michael Jackson', 474, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (436046120, 2835047, 'Love Never Felt So Good (DM-FK CLASSIC TRIBUTE MIX)', 'Michael Jackson', 504, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (436046121, 2835047, 'Love Never Felt So Good (DM RED ZONE MIX)', 'Michael Jackson', 412, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (504425097, 36128338, 'Blood on the Dance Floor X Dangerous (The White Panda Mash-Up)', 'Michael Jackson/The White Panda', 218, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512556, 36412398, 'This Place Hotel (a.k.a. Heartbreak Hotel)', 'The Jacksons', 343, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512557, 36412398, 'Threatened', 'Michael Jackson', 259, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512558, 36412398, 'Blood On The Dance Floor X Dangerous (The White Panda Mash-Up)', 'Michael Jackson', 218, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512559, 36412398, 'Blood on the Dance Floor', 'Michael Jackson', 254, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512560, 36412398, 'Torture', 'The Jacksons', 294, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512561, 36412398, 'Dirty Diana (2012 Remaster)', 'Michael Jackson', 281, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512562, 36412398, 'Ghosts', 'Michael Jackson', 313, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512563, 36412398, 'Unbreakable', 'Michael Jackson/The Notorious B.I.G.', 386, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512564, 36412398, 'Xscape', 'Michael Jackson', 245, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512565, 36412398, 'Thriller', 'Michael Jackson', 358, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512566, 36412398, 'Scream', 'Michael Jackson/Janet Jackson', 278, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512567, 36412398, 'Leave Me Alone (2012 Remaster)', 'Michael Jackson', 280, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512568, 36412398, 'Somebody\'s Watching Me (Single Version)', 'Rockwell/Michael Jackson', 236, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509512569, 36412398, 'Dangerous', 'Michael Jackson', 419, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (509633367, 36320406, 'Thriller (Steve Aoki Midnight Hour Remix)', 'Michael Jackson/Steve Aoki', 301, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562539879, 38978512, 'The Way You Make Me Feel (Live)', 'Michael Jackson', 186, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562539880, 38978512, 'Medley: Dangerous/Smooth Criminal (Live)', 'Michael Jackson', 272, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562539881, 38978512, 'You Are Not Alone (Live)', 'Michael Jackson', 216, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562539883, 38978512, 'Billie Jean (Live)', 'Michael Jackson', 62, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562540755, 38978512, 'Man in the Mirror (Live)', 'Michael Jackson', 402, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562540756, 38978512, 'Medley: Don\'t Stop \'Til You Get Enough/The Way You Make Me Feel/Scream/Beat It/Thriller/Black or Whi', 'Michael Jackson', 334, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562540759, 38978512, 'Jam (Live)', 'Michael Jackson', 117, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562540760, 38978512, 'Black or White (Live)', 'Michael Jackson', 204, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562540761, 38978512, 'We Are the World (Live)', 'Michael Jackson', 63, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562540762, 38978512, 'Heal the World (Live)', 'Michael Jackson', 225, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (562540763, 38978512, 'Gone Too Soon (Live)', 'Michael Jackson', 291, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299085650, 72148791, 'Love Never Felt So Good', 'Michael Jackson', 234, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299085651, 72148791, 'Slave to the Rhythm', 'Michael Jackson', 256, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299085652, 72148791, 'Xscape', 'Michael Jackson', 245, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299086011, 72148828, 'Love Never Felt So Good', 'Michael Jackson/Justin Timberlake', 245, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299086142, 72148773, 'Love Never Felt So Good', 'Michael Jackson', 234, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299086386, 72148791, 'Chicago', 'Michael Jackson', 245, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299086387, 72148791, 'Loving You', 'Michael Jackson', 195, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299086388, 72148791, 'A Place With No Name', 'Michael Jackson', 335, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299086389, 72148791, 'Do You Know Where Your Children Are', 'Michael Jackson', 276, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1299086390, 72148791, 'Blue Gangsta', 'Michael Jackson', 254, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1305365681, 72701829, 'Michael Jackson x Mark Ronson: Diamonds are Invincible', 'Michael Jackson/Mark Ronson', 300, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1421443440, 85476150, 'Intentions', 'Justin Bieber', 213, '/media/audio/1421443440.mp3', NULL, 30, 1, '[00:00.00] 作词 : Justin Bieber/Quavious Marshall/Jason \"Poo Bear\" Boyd/Dominic Jordan/Jimmy Giannos\n[00:01.00] 作曲 : Justin Bieber/Quavious Marshall/Jason \"Poo Bear\" Boyd/Dominic Jordan/Jimmy Giannos\n[00:13.27]Picture perfect, you don\'t need no filter\n[00:16.81]Gorgeous, make \'em drop dead, you\'re a killer\n[00:20.07]Shower you with all my attention\n[00:23.26]Yeah these are my only intentions\n[00:26.28]Stay in the kitchen cookin\' up, got your own bread\n[00:29.79]Heart full of equity you\'re an asset\n[00:33.07]Make sure that you don\'t need no mentions\n[00:36.35]Yeah these are my only intentions\n[00:39.56]Shout out to your mom and dad for makin\' you\n[00:42.80]Standin\' ovation, they did a great job raisin\' you\n[00:45.91]When I create you\'re my muse\n[00:48.76]The kind of smile that makes the news\n[00:52.22]Can\'t nobody throw shade on your name in these streets\n[00:55.77]Triple threat, you a boss, you a bae, you a beast\n[00:58.94]You make it easy to choose\n[01:01.60]You got a mean touch, I can\'t refuse (No I can\'t refuse it)\n[01:05.56]Picture perfect, you don\'t need no filter\n[01:08.64]Gorgeous, make \'em drop dead, you\'re a killer\n[01:11.93]Shower you with all my attention\n[01:15.22]Yeah these are my only intentions\n[01:18.20]Stay in the kitchen cookin\' up, got your own bread\n[01:21.71]Heart full of equity you\'re an asset\n[01:24.99]Make sure that you don\'t need no mentions\n[01:28.23]Yeah these are my only intentions\n[01:31.45]Already pass, you don\'t need no approval\n[01:34.71]Good everywhere, don\'t worry \'bout no refusal\n[01:37.86]Second to none, you got the upper hand now\n[01:41.07]Don\'t need a sponsor, nope, you\'re the brand now\n[01:44.29]You\'re my rock, my Colorado\n[01:47.15]Got that ring, just like Toronto\n[01:50.57]Love you now, a little more tomorrow\n[01:53.80]That\'s how I feel, act like you know that you are-\n[01:57.52]Picture perfect, you don\'t need no filter\n[02:00.60]Gorgeous, make \'em drop dead, you\'re a killer\n[02:03.83]Shower you with all my attention\n[02:07.04]Yeah these are my only intentions\n[02:10.30]Stay in the kitchen cookin\' up, got you\'re own bread (Whip it)\n[02:13.69]Heart full of equity you\'re an asset (Asset)\n[02:16.93]Make sure that you don\'t need no mentions (Yeah, yeah)\n[02:20.06]Yeah these are my only intentions (Quavo)\n[02:23.04]No cap, no pretendin\'\n[02:24.57]You don\'t need mentions (No cap)\n[02:25.75]Got \'em settin\' goals, they don\'t wanna be independent (\'Pendent)\n[02:28.91]Tell them to mind your business (Woo), we in our feelings\n[02:32.21]It\'s fifty-fifty percentage (Fifty)\n[02:33.71]Attention, we need commitment (Oh)\n[02:35.74]We got it both admitted (Both)\n[02:37.16]It\'s funny we both listen (Both)\n[02:38.75]It\'s a blessing (Blessing) \'cause we both get it (Both)\n[02:42.09]You the best thing and I don\'t need a witness (Best thing)\n[02:45.29]I\'ma find me a ring and pray it\'s perfect fitted (Perfect, perfect)\n[02:48.94]Picture perfect, you don\'t need no filter (No filter)\n[02:52.54]Gorgeous, make \'em drop dead, you\'re a killer (Oh-oh)\n[02:55.75]Shower you with all my attention (I will)\n[02:58.99]Yeah these are my only intentions (Yeah)\n[03:02.23]Stay in the kitchen cookin\' up, got your own bread (You do)\n[03:05.52]Heart full of equity you\'re an asset (Uh-uh)\n[03:08.74]Make sure that you don\'t need no mentions (No mentions)\n[03:11.94]Yeah these are my only intentions (Only intentions)\n[03:17.63]That\'s all I plan to do, ooh-ooh-ooh\n', 6, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46');
INSERT INTO `song` VALUES (1434492683, 86891768, 'Mind Is The Magic (Tess Remix)', 'Michael Jackson', 209, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1469116611, 93625092, 'Remeber the Time (Remix)', 'Michael Jackson/Efb Deejays', 337, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1480280185, 95611190, 'Holy', 'Justin Bieber/Chance the Rapper', 212, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902505, 96590962, 'This Place Hotel (Live)', 'Michael Jackson', 320, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902506, 96590962, 'Lovely One (Live)', 'Michael Jackson', 359, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902507, 96590962, 'Billie Jean (Live)', 'Michael Jackson', 369, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902508, 96590962, 'She\'s Out Of My Life (Live)', 'Michael Jackson', 259, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902509, 96590962, 'Things I Do For You (Live)', 'Michael Jackson', 202, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902510, 96590962, 'Off The Wall (Live)', 'Michael Jackson', 220, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902511, 96590962, 'Rock With You (Live)', 'Michael Jackson', 242, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902512, 96590962, 'Working Day And Night (Live)', 'Michael Jackson', 434, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902513, 96590962, 'I Want You Back / The Love You Save / Can You feel It? (Live)', 'Michael Jackson', 175, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902514, 96590962, 'Beat It (Live)', 'Michael Jackson', 385, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902515, 96590962, 'Human Nature (Live)', 'Michael Jackson', 268, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485902516, 96590962, 'Shake Your Body / Don\'t Stop \'til You Get Enough / Shake Your Body (Live)', 'Michael Jackson', 11, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1485905205, 96590962, 'Wanna Be Startin\' Somethin\' (Live)', 'Michael Jackson', 346, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1487478840, 96880875, 'Lonely', 'Justin Bieber/Benny Blanco', 149, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1487485880, 96881053, 'Lonely', 'Justin Bieber/Benny Blanco', 149, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1493104771, 97934805, 'Holy (Acoustic)', 'Justin Bieber/Chance the Rapper', 206, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1500390215, 99127353, 'Fa La La', 'Justin Bieber/Boyz II Men', 186, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1500390216, 99127353, 'Holy', 'Justin Bieber/Chance the Rapper', 212, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1500390217, 99127353, 'The Christmas Song (Chestnuts Roasting On An Open Fire)', 'Justin Bieber/Usher', 216, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1500390218, 99127353, 'Santa Claus Is Coming To Town', 'Justin Bieber', 217, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1500390219, 99127353, 'Drummer Boy', 'Justin Bieber/Busta Rhymes', 225, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1500391122, 99127353, 'Mistletoe', 'Justin Bieber', 184, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1808308957, 121043727, 'Anyone', 'Justin Bieber', 191, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1814025100, 121993236, 'Lonely (Acoustic)', 'Justin Bieber/Benny Blanco', 155, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1823431989, 123629087, 'Holy', 'Justin Bieber/Chance the Rapper', 212, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1823431990, 123629087, 'Lonely', 'Justin Bieber/Benny Blanco', 149, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1823434715, 123629087, 'Anyone', 'Justin Bieber', 191, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1823434717, 123629087, 'Holy (Acoustic)', 'Justin Bieber/Chance the Rapper', 206, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1823434718, 123629087, 'Lonely (Acoustic)', 'Justin Bieber/Benny Blanco', 155, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1824721655, 123857369, 'Hold On', 'Justin Bieber', 171, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1824725298, 123858074, 'Anyone', 'Justin Bieber', 191, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1824725300, 123858074, 'Hold On', 'Justin Bieber', 171, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830413514, 123858074, 'As I Am', 'Justin Bieber/Khalid', 174, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830413575, 123858074, 'Unstable', 'Justin Bieber/The Kid LAROI', 158, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830413582, 123858074, 'MLK Interlude', 'Justin Bieber', 104, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830414211, 123858074, '2 Much', 'Justin Bieber', 153, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830414245, 123858074, 'Deserve You', 'Justin Bieber', 187, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830414341, 123858074, 'Off My Face', 'Justin Bieber', 156, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830414377, 123858074, 'Holy', 'Justin Bieber/Chance the Rapper', 212, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830419909, 123858074, 'Somebody', 'Justin Bieber', 179, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830419924, 123858074, 'Peaches', 'Justin Bieber/Daniel Caesar/GIVĒON', 198, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830419942, 123858074, 'Love You Different', 'Justin Bieber/BEAM', 187, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830419990, 123858074, 'Lonely', 'Justin Bieber/Benny Blanco', 149, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830419997, 123858074, 'Angels Speak', 'Justin Bieber', 232, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830422729, 123858074, 'Die For You', 'Justin Bieber/Dominic Fike', 198, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830422741, 123858074, 'Ghost', 'Justin Bieber', 153, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1830422795, 123858074, 'Loved By You', 'Justin Bieber/Burna Boy', 159, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1832596903, 123858074, 'There She Go', 'Justin Bieber/Lil Uzi Vert', 215, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1832596923, 123858074, 'Lifetime', 'Justin Bieber', 207, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1832596925, 123858074, 'Wish You Would', 'Justin Bieber/Quavo', 241, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1832596944, 123858074, 'Know No Better', 'Justin Bieber/DaBaby', 162, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1832596947, 123858074, 'Name', 'Justin Bieber/Tori Kelly', 160, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1832597822, 123858074, 'I Can\'t Be Myself', 'Justin Bieber/Jaden', 193, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015138, 125595927, 'Where You Go I Follow', 'Justin Bieber/Pink Sweat$/Chandler Moore/Judah Smith', 213, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015139, 125595927, 'Afraid To Say', 'Justin Bieber/Lauren Walters', 263, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015142, 125595932, 'Freedom', 'Justin Bieber/BEAM', 165, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015143, 125595932, 'We’re In This Together', 'Justin Bieber', 182, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015144, 125595932, 'Where Do I Fit In', 'Justin Bieber/Tori Kelly/Chandler Moore/Judah Smith', 286, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015871, 125595927, 'Freedom', 'Justin Bieber/BEAM', 165, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015872, 125595927, 'All She Wrote', 'Justin Bieber/Brandon Love/Chandler Moore', 234, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015873, 125595927, 'We’re In This Together', 'Justin Bieber', 182, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015874, 125595927, 'Where Do I Fit In', 'Justin Bieber/Tori Kelly/Chandler Moore/Judah Smith', 286, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015876, 125595932, 'All She Wrote', 'Justin Bieber/Brandon Love/Chandler Moore', 234, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015877, 125595932, 'Where You Go I Follow', 'Justin Bieber/Pink Sweat$/Chandler Moore/Judah Smith', 213, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1835015878, 125595932, 'Afraid To Say', 'Justin Bieber/Lauren Walters', 263, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1851006899, 128520090, 'Peaches (Remix)', 'Justin Bieber/Ludacris/Usher/Snoop Dogg', 229, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1851006900, 128520091, 'Peaches (Remix)', 'Justin Bieber/Ludacris/Usher/Snoop Dogg', 229, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1856265846, 129525671, 'Peaches (Masterkraft Remix)', 'Justin Bieber/Alpha P/Omah Lay', 195, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1856265847, 129525672, 'Peaches (Masterkraft Remix)', 'Justin Bieber/Alpha P/Omah Lay', 195, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128936, 134452373, 'Deserve You', 'Justin Bieber', 187, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128937, 134452373, 'As I Am', 'Justin Bieber/Khalid', 174, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128938, 134452373, 'Off My Face', 'Justin Bieber', 156, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128939, 134452373, 'Unstable', 'Justin Bieber/The Kid LAROI', 158, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128940, 134452373, 'MLK Interlude', 'Justin Bieber', 104, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128941, 134452373, 'Hold On', 'Justin Bieber', 171, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128942, 134452373, 'Loved By You', 'Justin Bieber/Burna Boy', 159, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128943, 134452373, 'I Can\'t Be Myself', 'Justin Bieber/Jaden', 193, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128945, 134452379, 'As I Am', 'Justin Bieber/Khalid', 174, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128946, 134452379, 'Unstable', 'Justin Bieber/The Kid LAROI', 158, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128947, 134452379, 'Die For You', 'Justin Bieber/Dominic Fike', 198, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128948, 134452379, 'Somebody', 'Justin Bieber', 179, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128949, 134452379, 'Loved By You', 'Justin Bieber/Burna Boy', 159, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128950, 134452379, 'Anyone', 'Justin Bieber', 191, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128951, 134452379, 'Lonely', 'Justin Bieber/Benny Blanco', 149, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128952, 134452379, 'There She Go', 'Justin Bieber/Lil Uzi Vert', 215, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885128953, 134452379, 'I Can\'t Be Myself', 'Justin Bieber/Jaden', 193, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130645, 134452373, '2 Much', 'Justin Bieber', 153, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130646, 134452373, 'Holy', 'Justin Bieber/Chance the Rapper', 212, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130647, 134452373, 'Die For You', 'Justin Bieber/Dominic Fike', 198, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130648, 134452373, 'Somebody', 'Justin Bieber', 179, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130649, 134452373, 'Ghost', 'Justin Bieber', 153, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130650, 134452373, 'Peaches', 'Justin Bieber/Daniel Caesar/GIVĒON', 198, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130651, 134452373, 'Love You Different', 'Justin Bieber/BEAM', 187, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130652, 134452373, 'Anyone', 'Justin Bieber', 191, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130653, 134452373, 'Lonely', 'Justin Bieber/Benny Blanco', 149, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130654, 134452373, 'There She Go', 'Justin Bieber/Lil Uzi Vert', 215, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130655, 134452373, 'Lifetime', 'Justin Bieber', 207, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130656, 134452373, 'Wish You Would', 'Justin Bieber/Quavo', 241, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130657, 134452373, 'Know No Better', 'Justin Bieber/DaBaby', 162, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130658, 134452373, 'Name', 'Justin Bieber/Tori Kelly', 160, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130659, 134452373, 'Red Eye', 'Justin Bieber/TroyBoi', 187, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130660, 134452373, 'Angels Speak', 'Justin Bieber', 232, NULL, NULL, 30, 24, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130661, 134452373, 'Hailey', 'Justin Bieber', 193, NULL, NULL, 30, 25, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130665, 134452379, '2 Much', 'Justin Bieber', 153, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130666, 134452379, 'Deserve You', 'Justin Bieber', 187, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130667, 134452379, 'Off My Face', 'Justin Bieber', 156, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130668, 134452379, 'Holy', 'Justin Bieber/Chance the Rapper', 212, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130669, 134452379, 'MLK Interlude', 'Justin Bieber', 104, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130670, 134452379, 'Hold On', 'Justin Bieber', 171, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130671, 134452379, 'Ghost', 'Justin Bieber', 153, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130672, 134452379, 'Peaches', 'Justin Bieber/Daniel Caesar/GIVĒON', 198, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130673, 134452379, 'Love You Different', 'Justin Bieber/BEAM', 187, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130674, 134452379, 'Lifetime', 'Justin Bieber', 207, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130675, 134452379, 'Wish You Would', 'Justin Bieber/Quavo', 241, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130676, 134452379, 'Know No Better', 'Justin Bieber/DaBaby', 162, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130677, 134452379, 'Name', 'Justin Bieber/Tori Kelly', 160, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130678, 134452379, 'Red Eye', 'Justin Bieber/TroyBoi', 187, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130679, 134452379, 'Angels Speak', 'Justin Bieber', 232, NULL, NULL, 30, 24, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1885130680, 134452379, 'Hailey', 'Justin Bieber', 193, NULL, NULL, 30, 25, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1890657614, 135425606, 'Rockin\' Around The Christmas Tree', 'Justin Bieber', 133, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1941865700, 144051429, 'I Feel Funny', 'Justin Bieber', 76, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1941865734, 144052285, 'I Feel Funny', 'Justin Bieber', 76, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1942598263, 144185625, 'Honest', 'Justin Bieber/Don Toliver', 193, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1942599951, 144185643, 'Honest', 'Justin Bieber/Don Toliver', 193, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1976708166, 150619347, 'Beautiful Love (Free Fire)', 'Justin Bieber', 208, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367014, 155116994, 'Wanna Be Startin\' Somethin\'', 'Michael Jackson', 363, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367015, 155116994, 'Baby Be Mine', 'Michael Jackson', 261, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367016, 155116994, 'The Girl Is Mine', 'Michael Jackson/Paul McCartney', 223, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367017, 155116994, 'Thriller', 'Michael Jackson', 358, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367018, 155116994, 'Beat It', 'Michael Jackson', 258, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367019, 155116994, 'Billie Jean', 'Michael Jackson/Jeremy Lubbock', 294, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367020, 155116994, 'Human Nature', 'Michael Jackson', 246, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367021, 155116994, 'P.Y.T. (Pretty Young Thing)', 'Michael Jackson', 239, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367022, 155116994, 'Starlight', 'Michael Jackson', 304, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367023, 155116994, 'Behind The Mask (Mike\'s Mix (Demo))', 'Michael Jackson', 301, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367024, 155116994, 'Can\'t Get Outta The Rain', 'Michael Jackson', 246, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367025, 155116994, 'What A Lovely Way To Go (Demo)', 'Michael Jackson', 235, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367026, 155116994, 'She\'s Trouble (Demo)', 'Michael Jackson', 253, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367027, 155116994, 'Billie Jean (1981 Home Demo)', 'Michael Jackson', 140, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367028, 155116994, 'Billie Jean (Long Version)', 'Michael Jackson', 380, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367029, 155116994, 'Beat It (Demo)', 'Michael Jackson', 124, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367030, 155116994, 'Wanna Be Startin\' Somethin\' (2008 with Akon) (Thriller 25th Anniversary Remix)', 'Michael Jackson/Akon/Michael Jackson with Akon', 254, NULL, NULL, 30, 27, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367031, 155116994, 'P.Y.T. (Pretty Young Thing) (Demo Version)', 'Michael Jackson', 227, NULL, NULL, 30, 29, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367032, 155116994, 'P.Y.T. (Pretty Young Thing) (2008 with will.i.am) (Thriller 25th Anniversary Remix)', 'Michael Jackson/will.i.am/Michael Jackson with will.i.am', 261, NULL, NULL, 30, 30, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999367033, 155116994, 'The Girl Is Mine (2008 with will.i.am) (Thriller 25th Anniversary Remix)', 'Michael Jackson/will.i.am/Michael Jackson with will.i.am', 190, NULL, NULL, 30, 31, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369869, 155116994, 'The Lady in My Life', 'Michael Jackson', 299, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369870, 155116994, 'Got the Hots (Demo)', 'Michael Jackson', 265, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369871, 155116994, 'Who Do You Know (Demo)', 'Michael Jackson', 323, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369872, 155116994, 'Carousel', 'Michael Jackson', 219, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369873, 155116994, 'The Toy (Demo)', 'Michael Jackson', 184, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369874, 155116994, 'Sunset Driver (Demo)', 'Michael Jackson', 243, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369875, 155116994, 'Billie Jean (2008 Kanye West Mix) (Thriller 25th Anniversary Remix)', 'Michael Jackson/Kanye West/Michael Jackson feat. Kanye West', 276, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369876, 155116994, 'Beat It (2008 with Fergie Remix) (Thriller 25th Anniversary Remix)', 'Michael Jackson/Fergie/Michael Jackson with Fergie', 251, NULL, NULL, 30, 24, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369877, 155116994, 'Wanna Be Startin\' Somethin\' (Demo)', 'Michael Jackson', 343, NULL, NULL, 30, 25, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369878, 155116994, 'Wanna Be Startin\' Somethin\' (Tommy D\'s Main Mix)', 'Michael Jackson', 461, NULL, NULL, 30, 26, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369879, 155116994, 'Human Nature 7\"', 'Michael Jackson', 227, NULL, NULL, 30, 28, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369880, 155116994, 'Thriller 7\" (Special Edit)', 'Michael Jackson', 278, NULL, NULL, 30, 32, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369881, 155116994, 'Thriller (Def Thrill Mix)', 'Michael Jackson', 442, NULL, NULL, 30, 33, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (1999369882, 155116994, 'Thriller (Megamix)', 'Michael Jackson', 553, NULL, NULL, 30, 34, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682445, 158279235, 'Black Or White', 'Michael Jackson', 252, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682446, 158279235, 'Earth Song', 'Michael Jackson', 378, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682447, 158279235, 'History', 'Michael Jackson', 286, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682463, 158278421, 'Stranger In Moscow', 'Michael Jackson', 297, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682464, 158278421, 'Smooth Criminal', 'Michael Jackson', 359, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682465, 158278421, 'You Are Not Alone', 'Michael Jackson', 377, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682487, 158279244, 'Billie Jean', 'Michael Jackson', 369, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682488, 158279244, 'Shake Your Body / Don\'t Stop \'til You Get Enough / Shake Your Body', 'Michael Jackson', 754, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682489, 158279244, 'I Just Can\'t Stop Loving You', 'Michael Jackson', 396, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682490, 158279244, 'Bad', 'Michael Jackson', 396, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682491, 158279244, 'Michael Jackson Interview 1988 Part One', 'Michael Jackson', 471, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682492, 158279244, 'Michael Jackson Interview 1988 Part Two', 'Michael Jackson', 320, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682520, 158279265, 'Human Nature', 'Michael Jackson', 268, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682521, 158279265, 'I Want You Back_The Love You Save / Can You feel It', 'Michael Jackson', 175, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014682523, 158279265, 'Working Day And Night', 'Michael Jackson', 434, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687718, 158279235, 'Billie Jean', 'Michael Jackson', 482, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687719, 158279235, 'Thriller', 'Michael Jackson', 393, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687720, 158279235, 'Beat It', 'Michael Jackson', 419, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687721, 158279235, 'Heal The World', 'Michael Jackson', 501, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687734, 158278421, 'Scream', 'Michael Jackson', 153, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687735, 158278421, 'They Don\'t Care About Us', 'Michael Jackson', 168, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687736, 158278421, 'In The Closet', 'Michael Jackson', 84, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687737, 158278421, 'Wanna Be Startin\' Somethin\'', 'Michael Jackson', 313, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687738, 158278421, 'The Jackson 5 Medley', 'Michael Jackson', 473, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687772, 158279244, 'Beat It', 'Michael Jackson', 385, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687773, 158279244, 'Thriller', 'Michael Jackson', 255, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687804, 158279265, 'Wanna Be Startin\' Somethin\'', 'Michael Jackson', 346, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687805, 158279265, 'This Place Hotel', 'Michael Jackson', 320, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687806, 158279265, 'She\'s Out Of My Life', 'Michael Jackson', 259, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687807, 158279265, 'Things I Do For You', 'Michael Jackson', 202, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687809, 158279265, 'Off The Wall', 'Michael Jackson', 220, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687810, 158279265, 'Rock With You', 'Michael Jackson', 242, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2014687811, 158279265, 'Lovely One', 'Michael Jackson', 359, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057159368, 167959098, 'Wanna Be Startin\' Somethin\' (Live)', 'Michael Jackson', 436, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057159369, 167959098, 'Smooth Criminal (Live)', 'Michael Jackson', 379, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057159370, 167959098, 'I Just Can\'t Stop Loving You (Live)', 'Michael Jackson', 345, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057159371, 167959098, 'She\'s Out of My Life (Live)', 'Michael Jackson', 264, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057159372, 167959098, 'Rock With You (Live)', 'Michael Jackson', 427, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057159373, 167959098, 'Thriller (Live)', 'Michael Jackson', 363, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057159374, 167959098, 'Bad Groove (Live)', 'Michael Jackson', 847, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057159375, 167959098, 'Working Day and Night (Live)', 'Michael Jackson', 439, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057159376, 167959098, 'The Way You Make Me Feel (Live)', 'Michael Jackson', 976, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057167686, 167959098, 'Heartbreak Hotel (Live)', 'Michael Jackson', 285, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057167687, 167959098, 'Another Part of Me (Live)', 'Michael Jackson', 260, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057167688, 167959098, 'Human Nature (Live)', 'Michael Jackson', 356, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057167689, 167959098, 'I Want You Back- The Love You Save - I\'ll Be There (Medley) (Live)', 'Michael Jackson', 351, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057167690, 167959098, 'Beat it (Live)', 'Michael Jackson', 525, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057167691, 167959098, 'Billie Jean (Live)', 'Michael Jackson', 707, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057167692, 167959098, 'Bad (Live)', 'Michael Jackson', 371, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2057167693, 167959098, 'Man in the Mirror (Live)', 'Michael Jackson', 761, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2071560532, 171812353, 'Beat It（Necola Remix）', 'Michael Jackson/Necola', 193, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128484373, 186621345, 'ハートブレイク・ホテル (Live)', 'Michael Jackson', 284, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128484374, 186621345, 'ヒューマン・ネイチャー (Live)', 'Michael Jackson', 355, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128484375, 186621345, 'キャント・ストップ・ラヴィング・ユー (Live)', 'Michael Jackson', 344, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128484380, 186621345, 'ジャクソン5 メドレー（帰ってほしいの ＞ 小さな経験 ＞ アイル・ビー・ゼア） (Live)', 'Michael Jackson', 483, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128484381, 186621345, '今夜はビート・イット (Live)', 'Michael Jackson', 430, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128484382, 186621345, 'インタールード (Live)', 'Michael Jackson', 159, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128484383, 186621345, 'BAD (Live)', 'Michael Jackson', 988, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128484384, 186621345, 'ザ・ウェイ・ユー・メイク・ミー・フィール (Live)', 'Michael Jackson', 412, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485934, 186621345, 'イントロ (Live)', 'Michael Jackson', 86, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485935, 186621345, 'スタート・サムシング (Live)', 'Michael Jackson', 299, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485936, 186621345, 'アナザー・パート・オブ・ミー (Live)', 'Michael Jackson', 263, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485937, 186621345, 'スムーズ・クリミナル (Live)', 'Michael Jackson', 380, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485940, 186621345, 'あの娘が消えた (Live)', 'Michael Jackson', 281, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485941, 186621345, 'ロック・ウィズ・ユー (Live)', 'Michael Jackson', 282, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485942, 186621345, 'スリラー (Live)', 'Michael Jackson', 344, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485943, 186621345, 'バッド・グルーヴ (バンド・ジャム・セクション) [Live]', 'Michael Jackson', 858, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485944, 186621345, 'ワーキング・デイ・アンド・ナイト (Live)', 'Michael Jackson', 510, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485945, 186621345, 'ビリー・ジーン (Live)', 'Michael Jackson', 581, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2128485946, 186621345, 'マン・イン・ザ・ミラー (Live)', 'Michael Jackson', 658, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642895, 258371520, 'ヒューマン・ネイチャー (Live)', 'Michael Jackson', 267, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642896, 258371520, 'ハートブレイク・ホテル (Live)', 'Michael Jackson', 320, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642897, 258371520, 'ジャクソン5メドレー (Live)', 'Michael Jackson', 175, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642898, 258371520, 'あの娘が消えた (Live)', 'Michael Jackson', 259, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642899, 258371520, 'シングス・アイ・ドゥ・フォー・ユー (Live)', 'Michael Jackson', 201, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642900, 258371520, 'ロック・ウィズ・ユー (Live)', 'Michael Jackson', 242, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642901, 258371520, 'マイ・ラブリー・ワン (Live)', 'Michael Jackson', 359, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642902, 258371520, 'ワーキング・デイ・アンド・ナイト (Live)', 'Michael Jackson', 432, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642903, 258371520, '今夜はビート・イット (Live)', 'Michael Jackson', 385, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642904, 258371520, 'ビリー・ジーン (Live)', 'Michael Jackson', 369, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661642905, 258371520, 'シェイク・ユア・ボディ＞今夜はドント・ストップ＞シェイク・ユア・ボディ（リプリーズ） (Live)', 'Michael Jackson', 754, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661643767, 258371520, 'スタート・サムシング (Live)', 'Michael Jackson', 341, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661643768, 258371520, 'オフ・ザ・ウォール (Live)', 'Michael Jackson', 219, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661643769, 258371520, 'スリラー (Live)', 'Michael Jackson', 255, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661643770, 258371520, 'キャント・ストップ・ラヴィング・ユー (Live)', 'Michael Jackson', 395, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2661643771, 258371520, 'バッド (Live)', 'Michael Jackson', 396, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711893, 277997436, 'ALL I CAN TAKE', 'Justin Bieber', 248, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711894, 277997436, 'YUKON', 'Justin Bieber', 164, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-23 10:16:46', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711895, 277997436, 'BUTTERFLIES', 'Justin Bieber', 194, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711896, 277997436, 'FIRST PLACE', 'Justin Bieber', 200, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711897, 277997436, 'SOULFUL', 'Justin Bieber/Druski', 37, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711898, 277997436, 'DEVOTION', 'Justin Bieber/Dijon', 234, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711899, 277997436, 'DADZ LOVE', 'Justin Bieber/Lil B', 145, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711900, 277997436, 'THERAPY SESSION', 'Justin Bieber/Druski', 79, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711901, 277997436, 'SWEET SPOT', 'Justin Bieber/Sexyy Red', 185, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711902, 277997436, 'STANDING ON BUSINESS', 'Justin Bieber/Druski', 50, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711903, 277997436, '405', 'Justin Bieber', 213, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711904, 277997436, 'TOO LONG', 'Justin Bieber', 185, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711917, 277997444, 'THINGS YOU DO', 'Justin Bieber', 108, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711918, 277997444, 'BUTTERFLIES', 'Justin Bieber', 194, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711919, 277997444, 'FIRST PLACE', 'Justin Bieber', 200, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711920, 277997444, 'SOULFUL', 'Justin Bieber/Druski', 37, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711921, 277997444, 'GLORY VOICE MEMO', 'Justin Bieber', 85, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711922, 277997444, 'THERAPY SESSION', 'Justin Bieber/Druski', 79, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711923, 277997444, 'STANDING ON BUSINESS', 'Justin Bieber/Druski', 50, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724711924, 277997444, 'FORGIVENESS', 'Marvin Winans', 91, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714488, 277997436, 'DAISIES', 'Justin Bieber', 176, '/media/audio/2724714488.mp3', NULL, 30, 2, '[00:00.000] 作词 : Carter Lang/Eddie Benjamin/Dylan Wiggins/Daniel Chetrit/Justin Bieber/Dijon Duenas/Tobias Jesso Jr./Michael Gordon\n[00:01.000] 作曲 : Carter Lang/Eddie Benjamin/Dylan Wiggins/Daniel Chetrit/Justin Bieber/Dijon Duenas/Tobias Jesso Jr./Michael Gordon\n[00:18.108] Throwin\' petals like, \"Do you love me or not?\"\n[00:22.345] Head is spinnin\', and it don\'t know when to stop\n[00:26.687] You said \"Forever,\" babe, did you mean it or not?\n[00:31.006] Hold on, hold on\n[00:35.338] You leave me on read, babe, but I still get the message\n[00:39.679]Instead of a line it\'s three dots but I can connect \'em\n[00:44.174] And if it ain\'t right, babe, you know I respect it\n[00:48.385] But if you need time, just take your time\n[00:50.685] Honey, I get it, I get it, I get it\n[00:53.496]\n[00:54.460] Way you got me all in my head\n[00:58.781] Think I\'d rather you in my bed\n[01:02.551] Whatever it is, you know I can take it\n[01:05.986] I\'m countin\' the days, how many days \'til I can see you again?\n[01:10.247]\n[01:10.386]Blowing kisses like, \"Will you catch \'em or not?\"\n[01:14.511] I\'m Cupid with arrows, babe, I\'m just shootin my shot, mmm-mmm\n[01:18.980] If I could get in, drop me a pin, hop in the whip and come over\n[01:23.415] Don\'t wanna be friends, just skin-to-skin, I wanna get closer and closer and closer, uh\n[01:29.099]\n[01:29.422] The way you got me all in my head\n[01:33.622] Think I\'d rather you in my bed\n[01:37.328] Whatever it is, you know I can take it\n[01:40.705] I\'m countin\' the days, how many days \'til I can see you again?\n[01:43.773]\n[01:43.922] You got me all, all, all, all of my love (Holding my feelings, babe)\n[01:52.622] And you got me all, all, all, now I’m nodding my head\n[02:00.807] And you got me all, all, all, in my feelings, alright (You got me all in my head, you got me nodding my head, you got–)\n[02:10.030] ‘Cause you got me all, all, all in my feelings, every time (You got me all in my head, you got me nodding my head, you got–)\n[02:19.940]\n[02:21.474] The way you got me all in my head (The way you got me all in my head)\n[02:25.956] Think I\'d rather you in my bed\n[02:29.661] Whatever it is, you know I can take it\n[02:33.049] I\'m countin\' the days, how many days \'til I can see you again?\n', 19, 0, '2026-10-23 10:16:46', '2026-10-23 10:16:46');
INSERT INTO `song` VALUES (2724714489, 277997436, 'GO BABY', 'Justin Bieber', 195, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714490, 277997436, 'THINGS YOU DO', 'Justin Bieber', 108, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714491, 277997436, 'WAY IT IS', 'Justin Bieber/Gunna', 195, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714492, 277997436, 'WALKING AWAY', 'Justin Bieber', 244, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714493, 277997436, 'GLORY VOICE MEMO', 'Justin Bieber', 85, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714494, 277997436, 'SWAG', 'Justin Bieber/Cash Cobain/Eddie Benjamin', 150, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714495, 277997436, 'ZUMA HOUSE', 'Justin Bieber', 83, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714509, 277997444, 'ALL I CAN TAKE', 'Justin Bieber', 248, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714510, 277997444, 'DAISIES', 'Justin Bieber', 176, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714511, 277997444, 'YUKON', 'Justin Bieber', 164, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714512, 277997444, 'GO BABY', 'Justin Bieber', 195, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714513, 277997444, 'WAY IT IS', 'Justin Bieber/Gunna', 195, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714514, 277997444, 'WALKING AWAY', 'Justin Bieber', 244, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714515, 277997444, 'DEVOTION', 'Justin Bieber/Dijon', 234, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714516, 277997444, 'DADZ LOVE', 'Justin Bieber/Lil B', 145, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714517, 277997444, 'SWEET SPOT', 'Justin Bieber/Sexyy Red', 185, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714518, 277997444, '405', 'Justin Bieber', 213, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714519, 277997444, 'SWAG', 'Justin Bieber/Cash Cobain/Eddie Benjamin', 150, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714520, 277997444, 'ZUMA HOUSE', 'Justin Bieber', 83, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714521, 277997444, 'TOO LONG', 'Justin Bieber', 185, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2724714639, 277997436, 'FORGIVENESS', 'Marvin Winans', 91, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481009, 284075851, 'SPEED DEMON', 'Justin Bieber', 212, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481010, 284075851, 'LOVE SONG', 'Justin Bieber', 172, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481011, 284075851, 'I DO', 'Justin Bieber', 224, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481012, 284075851, 'MOTHER IN YOU', 'Justin Bieber', 206, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481013, 284075851, 'DON\'T WANNA', 'Justin Bieber/Bakar', 166, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481014, 284075851, 'BAD HONEY', 'Justin Bieber', 156, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481015, 284075851, 'NEED IT', 'Justin Bieber', 219, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481016, 284075851, 'POPPIN’ MY S***', 'Justin Bieber/Hurricane Chris', 127, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481017, 284075851, 'ALL THE WAY', 'Justin Bieber', 201, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481018, 284075851, 'WHEN IT\'S OVER', 'Justin Bieber', 155, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481019, 284075851, 'EVERYTHING HALLELUJAH', 'Justin Bieber', 249, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481020, 284075851, 'YUKON', 'Justin Bieber', 164, NULL, NULL, 30, 26, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481021, 284075851, 'GO BABY', 'Justin Bieber', 195, NULL, NULL, 30, 27, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481022, 284075851, 'BUTTERFLIES', 'Justin Bieber', 194, NULL, NULL, 30, 29, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481023, 284075851, 'FIRST PLACE', 'Justin Bieber', 200, NULL, NULL, 30, 31, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481024, 284075851, 'SOULFUL', 'Justin Bieber/Druski', 37, NULL, NULL, 30, 32, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481025, 284075851, 'WALKING AWAY', 'Justin Bieber', 244, NULL, NULL, 30, 33, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481026, 284075851, 'GLORY VOICE MEMO', 'Justin Bieber', 85, NULL, NULL, 30, 34, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481027, 284075851, 'DADZ LOVE', 'Justin Bieber/Lil B', 145, NULL, NULL, 30, 36, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481028, 284075851, 'SWEET SPOT', 'Justin Bieber/Sexyy Red', 185, NULL, NULL, 30, 38, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481029, 284075851, '405', 'Justin Bieber', 213, NULL, NULL, 30, 40, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481030, 284075851, 'SWAG', 'Justin Bieber/Cash Cobain/Eddie Benjamin', 150, NULL, NULL, 30, 41, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481031, 284075851, 'TOO LONG', 'Justin Bieber', 185, NULL, NULL, 30, 43, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743481032, 284075851, 'FORGIVENESS', 'Marvin Winans', 91, NULL, NULL, 30, 44, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486296, 284075851, 'BETTER MAN', 'Justin Bieber', 169, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486297, 284075851, 'I THINK YOU\'RE SPECIAL', 'Justin Bieber/Tems', 166, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486298, 284075851, 'WITCHYA', 'Justin Bieber', 163, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486299, 284075851, 'EYE CANDY', 'Justin Bieber', 238, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486300, 284075851, 'OH MAN', 'Justin Bieber', 192, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486301, 284075851, 'PETTING ZOO', 'Justin Bieber', 197, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486302, 284075851, 'MOVING FAST', 'Justin Bieber', 202, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486303, 284075851, 'SAFE SPACE', 'Justin Bieber/Lil B', 194, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486304, 284075851, 'LYIN\'', 'Justin Bieber', 187, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486305, 284075851, 'DOTTED LINE', 'Justin Bieber', 148, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486306, 284075851, 'OPEN UP YOUR HEART', 'Justin Bieber/Eddie Benjamin', 214, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486307, 284075851, 'STORY OF GOD', 'Justin Bieber', 466, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486308, 284075851, 'ALL I CAN TAKE', 'Justin Bieber', 248, NULL, NULL, 30, 24, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486309, 284075851, 'DAISIES', 'Justin Bieber', 176, NULL, NULL, 30, 25, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486310, 284075851, 'THINGS YOU DO', 'Justin Bieber', 108, NULL, NULL, 30, 28, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486311, 284075851, 'WAY IT IS', 'Justin Bieber/Gunna', 195, NULL, NULL, 30, 30, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486312, 284075851, 'DEVOTION', 'Justin Bieber/Dijon', 234, NULL, NULL, 30, 35, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486313, 284075851, 'THERAPY SESSION', 'Justin Bieber/Druski', 79, NULL, NULL, 30, 37, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486314, 284075851, 'STANDING ON BUSINESS', 'Justin Bieber/Druski', 50, NULL, NULL, 30, 39, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2743486315, 284075851, 'ZUMA HOUSE', 'Justin Bieber', 83, NULL, NULL, 30, 42, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417785, 285096821, 'BETTER MAN', 'Justin Bieber', 169, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417786, 285096821, 'LOVE SONG', 'Justin Bieber', 172, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417787, 285096821, 'I THINK YOU\'RE SPECIAL', 'Justin Bieber/Tems', 166, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417788, 285096821, 'EYE CANDY', 'Justin Bieber', 238, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417789, 285096821, 'POPPIN’ MY S***', 'Justin Bieber/Hurricane Chris', 127, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417790, 285096821, 'PETTING ZOO', 'Justin Bieber', 197, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417791, 285096821, 'OPEN UP YOUR HEART', 'Justin Bieber/Eddie Benjamin', 214, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417792, 285096821, 'WHEN IT\'S OVER', 'Justin Bieber', 155, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417793, 285096821, 'EVERYTHING HALLELUJAH', 'Justin Bieber', 249, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417794, 285096821, 'STORY OF GOD', 'Justin Bieber', 466, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417795, 285096821, 'ALL I CAN TAKE', 'Justin Bieber', 248, NULL, NULL, 30, 24, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417796, 285096821, 'DAISIES', 'Justin Bieber', 176, NULL, NULL, 30, 25, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417797, 285096821, 'GO BABY', 'Justin Bieber', 195, NULL, NULL, 30, 27, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417798, 285096821, 'BUTTERFLIES', 'Justin Bieber', 194, NULL, NULL, 30, 29, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417799, 285096821, 'FIRST PLACE', 'Justin Bieber', 200, NULL, NULL, 30, 31, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417800, 285096821, 'GLORY VOICE MEMO', 'Justin Bieber', 85, NULL, NULL, 30, 34, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417801, 285096821, 'THERAPY SESSION', 'Justin Bieber/Druski', 79, NULL, NULL, 30, 37, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417802, 285096821, '405', 'Justin Bieber', 213, NULL, NULL, 30, 40, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746417803, 285096821, 'ZUMA HOUSE', 'Justin Bieber', 83, NULL, NULL, 30, 42, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418419, 285096821, 'SPEED DEMON', 'Justin Bieber', 212, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418420, 285096821, 'I DO', 'Justin Bieber', 224, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418421, 285096821, 'MOTHER IN YOU', 'Justin Bieber', 206, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418422, 285096821, 'WITCHYA', 'Justin Bieber', 163, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418423, 285096821, 'DON\'T WANNA', 'Justin Bieber/Bakar', 166, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418424, 285096821, 'BAD HONEY', 'Justin Bieber', 156, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418425, 285096821, 'NEED IT', 'Justin Bieber', 219, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418426, 285096821, 'OH MAN', 'Justin Bieber', 192, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418427, 285096821, 'ALL THE WAY', 'Justin Bieber', 201, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418428, 285096821, 'MOVING FAST', 'Justin Bieber', 202, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418429, 285096821, 'SAFE SPACE', 'Justin Bieber/Lil B', 194, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418430, 285096821, 'LYIN\'', 'Justin Bieber', 187, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418431, 285096821, 'DOTTED LINE', 'Justin Bieber', 148, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418432, 285096821, 'YUKON', 'Justin Bieber', 164, NULL, NULL, 30, 26, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418433, 285096821, 'THINGS YOU DO', 'Justin Bieber', 108, NULL, NULL, 30, 28, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418434, 285096821, 'WAY IT IS', 'Justin Bieber/Gunna', 195, NULL, NULL, 30, 30, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418435, 285096821, 'SOULFUL', 'Justin Bieber/Druski', 37, NULL, NULL, 30, 32, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418436, 285096821, 'WALKING AWAY', 'Justin Bieber', 244, NULL, NULL, 30, 33, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418437, 285096821, 'DEVOTION', 'Justin Bieber/Dijon', 234, NULL, NULL, 30, 35, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418438, 285096821, 'DADZ LOVE', 'Justin Bieber/Lil B', 145, NULL, NULL, 30, 36, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418439, 285096821, 'SWEET SPOT', 'Justin Bieber/Sexyy Red', 185, NULL, NULL, 30, 38, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418440, 285096821, 'STANDING ON BUSINESS', 'Justin Bieber/Druski', 50, NULL, NULL, 30, 39, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418441, 285096821, 'SWAG', 'Justin Bieber/Cash Cobain/Eddie Benjamin', 150, NULL, NULL, 30, 41, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418442, 285096821, 'TOO LONG', 'Justin Bieber', 185, NULL, NULL, 30, 43, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (2746418443, 285096821, 'FORGIVENESS', 'Marvin Winans', 91, NULL, NULL, 30, 44, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161736, 369123751, 'Got To Be There (Single Version)', 'Michael Jackson', 203, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161738, 369123751, 'ABC', 'Jackson 5', 177, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161739, 369123751, 'I\'ll Be There', 'Jackson 5', 238, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161740, 369123751, 'I Wanna Be Where You Are', 'Michael Jackson', 178, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161742, 369123751, 'Doggin\' Around', 'Michael Jackson', 145, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161744, 369123751, 'You\'ve Changed', 'Jackson 5', 181, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161746, 369123751, 'Who\'s Lovin\' You (Single Version)', 'Jackson 5', 262, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161750, 369123751, 'Music And Me', 'Michael Jackson', 156, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161752, 369123751, 'We\'ve Got A Good Thing Going (Single Version)', 'Michael Jackson', 182, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161753, 369123751, 'Maybe Tomorrow', 'Jackson 5', 285, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161754, 369123751, 'Just A Little Bit Of You', 'Michael Jackson', 191, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161755, 369123751, 'The Love You Save', 'Jackson 5', 179, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161756, 369123751, 'Ben (Live at the Forum, 1972)', 'Jackson 5', 159, NULL, NULL, 30, 25, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366161757, 369123751, 'I\'ll Be There (Live at the Forum, 1972)', 'Jackson 5', 244, NULL, NULL, 30, 26, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162223, 369123751, 'I Want You Back', 'Jackson 5', 178, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162228, 369123751, 'Rockin\' Robin', 'Michael Jackson', 152, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162230, 369123751, 'Never Can Say Goodbye (Single Version)', 'Jackson 5', 179, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162234, 369123751, 'Ain\'t No Sunshine', 'Michael Jackson', 251, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162235, 369123751, 'With A Child\'s Heart', 'Michael Jackson', 208, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162237, 369123751, 'Mama\'s Pearl', 'Jackson 5', 186, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162238, 369123751, 'Stand!', 'Jackson 5', 155, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162239, 369123751, 'We\'re Almost There', 'Michael Jackson', 227, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162240, 369123751, 'Dancing Machine (Single Version)', 'Jackson 5', 162, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162241, 369123751, 'One Day In Your Life', 'Michael Jackson', 256, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162242, 369123751, 'Farewell My Summer Love', 'Michael Jackson', 265, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3366162243, 369123751, 'Medley: I Want You Back/ABC/The Love You Save (Live In Japan / 1973)', 'Jackson 5', 179, NULL, NULL, 30, 24, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372880499, 372193574, 'I\'ll Be There', 'Jackson 5', 239, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372880500, 372193574, 'Who\'s Lovin\' You', 'Jackson 5', 239, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372880501, 372193574, 'Medley: I Want You Back / ABC / The Love You Save', 'The Jacksons', 180, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372880503, 372193574, 'Thriller', 'Michael Jackson', 358, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372880504, 372193574, 'Billie Jean', 'Michael Jackson', 294, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372880505, 372193574, 'Wanna Be Startin\' Somethin\'', 'Michael Jackson', 364, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372880506, 372193574, 'Human Nature', 'Michael Jackson', 246, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372880510, 372193574, 'Bad (2012 Remaster)', 'Michael Jackson', 248, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372881417, 372193574, 'Never Can Say Goodbye (Single Version)', 'Jackson 5', 181, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372881418, 372193574, 'Ben (Live from the 1981 U.S. Tour)', 'The Jacksons', 186, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372881419, 372193574, 'Don\'t Stop \'Til You Get Enough', 'Michael Jackson', 365, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372881420, 372193574, 'Beat It', 'Michael Jackson', 259, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3372881425, 372193574, 'Workin\' Day and Night', 'Michael Jackson', 314, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228696, 383765118, 'FIRST PLACE', 'Justin Bieber', 202, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228697, 383765118, 'GO BABY', 'Justin Bieber', 200, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228698, 383765118, '405', 'Justin Bieber', 157, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228699, 383765118, 'TOO LONG', 'Justin Bieber', 84, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228700, 383765118, 'PETTING ZOO', 'Justin Bieber', 78, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228703, 383765118, 'THINGS YOU DO (Acoustic)', 'Justin Bieber', 138, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228705, 383765118, 'ZUMA HOUSE (Acoustic)', 'Justin Bieber', 111, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228708, 383765118, 'EVERYTHING HALLELUJAH (Acoustic)', 'Justin Bieber', 275, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228710, 383765118, 'YUKON', 'Justin Bieber', 175, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228713, 383765118, 'I THINK YOU\'RE SPECIAL', 'Justin Bieber/Tems', 175, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398228715, 383765118, 'DAISIES', 'Justin Bieber', 258, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229343, 383765118, 'ALL I CAN TAKE', 'Justin Bieber', 233, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229344, 383765118, 'SPEED DEMON', 'Justin Bieber', 212, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229345, 383765118, 'BUTTERFLIES', 'Justin Bieber', 184, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229346, 383765118, 'WALKING AWAY', 'Justin Bieber', 236, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229347, 383765118, 'ALL THE WAY', 'Justin Bieber', 100, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229350, 383765118, 'I DO', 'Justin Bieber', 144, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229351, 383765118, 'STAY', 'Justin Bieber/The Kid LAROI', 152, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229353, 383765118, 'GLORY VOICE MEMO (Acoustic)', 'Justin Bieber', 91, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229355, 383765118, 'DOTTED LINE (Acoustic)', 'Justin Bieber', 159, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229358, 383765118, 'DEVOTION', 'Justin Bieber/Dijon', 219, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3398229360, 383765118, 'ESSENCE', 'Justin Bieber/WizKid/Tems', 252, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031696, 385010222, 'SPEED DEMON', 'Justin Bieber', 210, NULL, NULL, 30, 2, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031697, 385010222, 'GO BABY', 'Justin Bieber', 198, NULL, NULL, 30, 4, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031698, 385010222, 'BUTTERFLIES', 'Justin Bieber', 189, NULL, NULL, 30, 5, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031699, 385010222, 'LYIN\'', 'Justin Bieber', 164, NULL, NULL, 30, 6, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031701, 385010222, 'WALKING AWAY', 'Justin Bieber', 250, NULL, NULL, 30, 7, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031702, 385010222, '405', 'Justin Bieber', 157, NULL, NULL, 30, 9, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031703, 385010222, 'TOO LONG', 'Justin Bieber', 110, NULL, NULL, 30, 10, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031704, 385010222, 'I DO', 'Justin Bieber', 150, NULL, NULL, 30, 12, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031705, 385010222, 'MOTHER IN YOU (Acoustic)', 'Justin Bieber', 219, NULL, NULL, 30, 14, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031706, 385010222, 'THINGS YOU DO (Acoustic)', 'Justin Bieber', 108, NULL, NULL, 30, 15, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031707, 385010222, 'GLORY VOICE MEMO (Acoustic)', 'Justin Bieber', 93, NULL, NULL, 30, 16, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031708, 385010222, 'ZUMA HOUSE (Acoustic)', 'Justin Bieber', 98, NULL, NULL, 30, 17, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031709, 385010222, 'EVERYTHING HALLELUJAH (Acoustic)', 'Justin Bieber', 268, NULL, NULL, 30, 19, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401031710, 385010222, 'YUKON', 'Justin Bieber', 169, NULL, NULL, 30, 20, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401032226, 385010222, 'ALL I CAN TAKE', 'Justin Bieber', 220, NULL, NULL, 30, 1, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401032227, 385010222, 'FIRST PLACE', 'Justin Bieber', 208, NULL, NULL, 30, 3, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401032228, 385010222, 'ALL THE WAY', 'Justin Bieber', 165, NULL, NULL, 30, 8, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401032229, 385010222, 'PETTING ZOO', 'Justin Bieber', 77, NULL, NULL, 30, 11, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401032230, 385010222, 'SWEET SPOT', 'Justin Bieber/Sexyy Red', 199, NULL, NULL, 30, 13, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401032231, 385010222, 'DOTTED LINE (Acoustic)', 'Justin Bieber', 163, NULL, NULL, 30, 18, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401032232, 385010222, 'DEVOTION', 'Justin Bieber/Dijon', 224, NULL, NULL, 30, 21, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401032233, 385010222, 'SNOOZE', 'Justin Bieber/SZA', 225, NULL, NULL, 30, 22, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');
INSERT INTO `song` VALUES (3401032234, 385010222, 'DAISIES', 'Justin Bieber', 259, NULL, NULL, 30, 23, NULL, 0, 0, '2026-10-30 15:20:31', '2026-10-30 15:20:31');

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
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '库存流水表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stock_log
-- ----------------------------
INSERT INTO `stock_log` VALUES (6, 379730914, 2, 50, 48, 'ORD1793240506725272', 1, '用户下单扣减库存', '2026-10-29 10:21:46');
INSERT INTO `stock_log` VALUES (7, 379730914, 2, 48, 50, 'ORD1793240506725272', 2, '订单取消或超时后恢复库存', '2026-10-29 10:22:13');
INSERT INTO `stock_log` VALUES (8, 379730914, 1, 50, 49, 'ORD17932405588302027', 1, '用户下单扣减库存', '2026-10-29 10:22:38');
INSERT INTO `stock_log` VALUES (9, 379730914, 1, 49, 50, 'ORD17932405588302027', 2, '订单取消或超时后恢复库存', '2026-10-29 10:23:00');
INSERT INTO `stock_log` VALUES (10, 6293, 1, 100, 99, 'ORD17932410556052668', 1, '用户下单扣减库存', '2026-10-29 10:30:55');
INSERT INTO `stock_log` VALUES (11, 6293, 1, 99, 100, 'ORD17932410556052668', 2, '订单取消或超时后恢复库存', '2026-10-29 10:31:32');
INSERT INTO `stock_log` VALUES (12, 7547, 2, 100, 98, 'ORD17932411228126411', 1, '用户下单扣减库存', '2026-10-29 10:32:02');
INSERT INTO `stock_log` VALUES (13, 7547, 2, 98, 100, 'ORD17932411228126411', 2, '订单取消或超时后恢复库存', '2026-10-29 10:32:04');
INSERT INTO `stock_log` VALUES (14, 379730914, 1, 50, 49, 'ORD17932416574632322', 1, '用户下单扣减库存', '2026-10-29 10:40:57');
INSERT INTO `stock_log` VALUES (15, 6293, 1, 100, 99, 'ORD17932416574632322', 1, '用户下单扣减库存', '2026-10-29 10:40:57');
INSERT INTO `stock_log` VALUES (16, 7547, 2, 100, 98, 'ORD17932416574632322', 1, '用户下单扣减库存', '2026-10-29 10:40:57');
INSERT INTO `stock_log` VALUES (17, 379730914, 1, 49, 48, 'ORD17932416909592883', 1, '用户下单扣减库存', '2026-10-29 10:41:30');
INSERT INTO `stock_log` VALUES (19, 8100, 2, 100, 98, 'ORD17932417296921604', 1, '用户下单扣减库存', '2026-10-29 10:42:09');
INSERT INTO `stock_log` VALUES (20, 13352, 1, 100, 99, 'ORD17932417296921604', 1, '用户下单扣减库存', '2026-10-29 10:42:09');
INSERT INTO `stock_log` VALUES (21, 8100, 2, 98, 100, 'ORD17932417296921604', 2, '订单取消或超时后恢复库存', '2026-10-29 10:42:10');
INSERT INTO `stock_log` VALUES (22, 13352, 1, 99, 100, 'ORD17932417296921604', 2, '订单取消或超时后恢复库存', '2026-10-29 10:42:10');
INSERT INTO `stock_log` VALUES (23, 379730914, 1, 48, 49, 'ORD17932416909592883', 2, '订单取消或超时后恢复库存', '2026-10-29 10:57:00');
INSERT INTO `stock_log` VALUES (24, 379730914, 1, 49, 48, 'ORD1793326066441378', 1, '用户下单扣减库存', '2026-10-30 10:07:46');
INSERT INTO `stock_log` VALUES (25, 6293, 1, 99, 98, 'ORD17933261482193699', 1, '用户下单扣减库存', '2026-10-30 10:09:08');
INSERT INTO `stock_log` VALUES (26, 379730914, 1, 48, 49, 'ORD1793326066441378', 2, '订单取消或超时后恢复库存', '2026-10-30 10:23:00');
INSERT INTO `stock_log` VALUES (27, 6293, 1, 98, 99, 'ORD17933261482193699', 2, '订单取消或超时后恢复库存', '2026-10-30 10:25:00');
INSERT INTO `stock_log` VALUES (28, 8100, 1, 100, 99, 'ORD1793328405647134', 1, '用户下单扣减库存', '2026-10-30 10:46:45');
INSERT INTO `stock_log` VALUES (29, 8100, 1, 99, 100, 'ORD1793328405647134', 2, '订单取消或超时后恢复库存', '2026-10-30 11:02:00');
INSERT INTO `stock_log` VALUES (30, 8100, 1, 100, 99, 'ORD17933301772741181', 1, '用户下单扣减库存', '2026-10-30 11:16:17');
INSERT INTO `stock_log` VALUES (31, 6293, 1, 99, 98, 'ORD17933302459914498', 1, '用户下单扣减库存', '2026-10-30 11:17:25');
INSERT INTO `stock_log` VALUES (32, 6293, 1, 98, 99, 'ORD17933302459914498', 2, '订单取消或超时后恢复库存', '2026-10-30 11:17:27');
INSERT INTO `stock_log` VALUES (33, 8100, 1, 99, 100, 'ORD17933301772741181', 2, '订单取消或超时后恢复库存', '2026-10-30 14:01:00');
INSERT INTO `stock_log` VALUES (34, 379730914, 1, 49, 48, 'ORD17933400656247502', 1, '用户下单扣减库存', '2026-10-30 14:01:05');
INSERT INTO `stock_log` VALUES (35, 6293, 1, 99, 98, 'ORD17933401802136117', 1, '用户下单扣减库存', '2026-10-30 14:03:00');
INSERT INTO `stock_log` VALUES (36, 8100, 1, 100, 99, 'ORD17933405017479363', 1, '用户下单扣减库存', '2026-10-30 14:08:21');
INSERT INTO `stock_log` VALUES (37, 6293, 1, 98, 97, 'ORD17933406567996926', 1, '用户下单扣减库存', '2026-10-30 14:10:56');
INSERT INTO `stock_log` VALUES (38, 6293, 1, 97, 98, 'ORD17933406567996926', 2, '订单取消或超时后恢复库存', '2026-10-30 14:16:33');
INSERT INTO `stock_log` VALUES (39, 379730914, 1, 48, 49, 'ORD17933400656247502', 2, '订单取消或超时后恢复库存', '2026-10-30 14:17:00');
INSERT INTO `stock_log` VALUES (40, 6293, 1, 98, 99, 'ORD17933401802136117', 2, '订单取消或超时后恢复库存', '2026-10-30 14:18:00');
INSERT INTO `stock_log` VALUES (41, 8100, 1, 99, 100, 'ORD17933405017479363', 2, '订单取消或超时后恢复库存', '2026-10-30 14:24:00');
INSERT INTO `stock_log` VALUES (42, 8100, 1, 100, 99, 'ORD17933415707883417', 1, '用户下单扣减库存', '2026-10-30 14:26:10');
INSERT INTO `stock_log` VALUES (43, 8100, 1, 99, 100, 'ORD17933415707883417', 2, '订单取消或超时后恢复库存', '2026-10-30 14:26:12');
INSERT INTO `stock_log` VALUES (44, 13361, 1, 100, 99, 'ORD17933416786448081', 1, '用户下单扣减库存', '2026-10-30 14:27:58');
INSERT INTO `stock_log` VALUES (45, 13361, 1, 99, 100, 'ORD17933416786448081', 2, '订单取消或超时后恢复库存', '2026-10-30 14:43:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'testuser', '0c9023f5706d3d5defee107ba6c12d99', '测试用户', '13800138000', 'test@example.com', NULL, 1, 'user', 0, '2026-10-15 10:05:57', '2026-10-15 10:05:57');
INSERT INTO `sys_user` VALUES (2, 'test00', '0c9023f5706d3d5defee107ba6c12d99', '测试人员', '13489681238', '1111@qq.com', NULL, 1, 'user', 0, '2026-10-22 00:11:36', '2026-10-22 00:11:36');
INSERT INTO `sys_user` VALUES (3, 'test01', '0c9023f5706d3d5defee107ba6c12d99', 'tester01', '13900001111', 'test01@mail.com', '/media/image/avatar-3-dc5d96eced0f42d48357ae3fb5761fc9.png', 1, 'user', 0, '2026-10-23 10:20:03', '2026-10-23 10:20:03');
INSERT INTO `sys_user` VALUES (4, 'admintest', 'cb808b9e8d874a5979347a64bd3f2a51', 'admintest', NULL, NULL, NULL, 1, 'admin', 0, '2026-10-29 10:30:23', '2026-10-29 10:30:23');
INSERT INTO `sys_user` VALUES (5, 'pwtest', '91694e63f0f4848ccc588dd9c0010edc', 'pwtest', NULL, NULL, NULL, 1, 'user', 0, '2026-10-29 11:07:26', '2026-10-29 11:07:26');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收货地址表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_address
-- ----------------------------
INSERT INTO `user_address` VALUES (1, 3, 'Tester', '13800001111', 'Beijing', 'Beijing', 'Haidian', 'St.1 No.1', 0, '2026-10-29 10:30:55', '2026-10-30 10:04:44', 0);
INSERT INTO `user_address` VALUES (2, 3, 'PM Tester', '13800001234', 'Beijing', 'Beijing', 'Haidian', 'PM Street No.1', 1, '2026-10-30 10:04:44', '2026-10-30 10:04:44', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户抽奖统计表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_draw_stat
-- ----------------------------
INSERT INTO `user_draw_stat` VALUES (1, 3, 2, 12, 3, 10, '2026-10-30 14:52:46', '2026-10-29 10:53:36', '2026-10-30 14:52:46');

SET FOREIGN_KEY_CHECKS = 1;
