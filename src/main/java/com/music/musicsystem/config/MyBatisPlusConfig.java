
package com.music.musicsystem.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import com.baomidou.mybatisplus.spring.MybatisSqlSessionFactoryBean;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.baomidou.mybatisplus.core.config.GlobalConfig;

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

        GlobalConfig globalConfig = new GlobalConfig();
        globalConfig.setMetaObjectHandler(metaObjectHandler());
        factory.setGlobalConfig(globalConfig);

        // 自定义 SqlSessionFactory 会使 starter 自动装配退避，分页插件必须手动挂载
        factory.setPlugins(mybatisPlusInterceptor());

        MybatisConfiguration configuration = new MybatisConfiguration();

        configuration.setMapUnderscoreToCamelCase(true);
        configuration.setLogImpl(
                org.apache.ibatis.logging.stdout.StdOutImpl.class
        );

        factory.setConfiguration(configuration);

        return factory.getObject();
    }

    /**
     * MyBatis-Plus 内置拦截器链：注册 MySQL 方言的分页插件，
     * 使 selectPage 自动执行 COUNT 查询并追加 LIMIT 子句。
     */
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
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