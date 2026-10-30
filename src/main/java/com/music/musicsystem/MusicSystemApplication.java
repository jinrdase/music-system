package com.music.musicsystem;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 音乐系统主启动类
 */
@SpringBootApplication
@MapperScan("com.music.musicsystem.mapper")
@EnableScheduling
public class MusicSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(MusicSystemApplication.class, args);
    }
}