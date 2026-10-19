
package com.music.musicsystem.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.spring.MybatisSqlSessionFactoryBean;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import java.time.LocalDateTime;

/**
 * 配置 MyBatis-Plus 会话工厂、字段映射和时间自动填充。
 */

@Configuration
public class MyBatisPlusConfig {

    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource)
            throws Exception {

        MybatisSqlSessionFactoryBean factory =
                new MybatisSqlSessionFactoryBean();

        factory.setDataSource(dataSource);
        factory.setTypeAliasesPackage("com.music.musicsystem.entity");

        MybatisConfiguration configuration = new MybatisConfiguration();

        configuration.setMapUnderscoreToCamelCase(true);
        configuration.setLogImpl(
                org.apache.ibatis.logging.stdout.StdOutImpl.class
        );

        factory.setConfiguration(configuration);

        return factory.getObject();
    }
    /**
     * 创建用于自动填充审计时间字段的处理器。
     */

    @Bean
    public MetaObjectHandler metaObjectHandler() {
        return new MetaObjectHandler() {
            /**
             * 插入数据时自动填充创建时间和更新时间。
             */

            @Override
            public void insertFill(MetaObject metaObject) {
                LocalDateTime now = LocalDateTime.now();

                this.strictInsertFill(
                        metaObject, "createTime",
                        LocalDateTime.class, now
                );

                this.strictInsertFill(
                        metaObject, "updateTime",
                        LocalDateTime.class, now
                );
            }
            /**
             * 更新数据时自动填充更新时间。
             */

            @Override
            public void updateFill(MetaObject metaObject) {
                this.strictUpdateFill(
                        metaObject, "updateTime",
                        LocalDateTime.class, LocalDateTime.now()
                );
            }
        };
    }
}