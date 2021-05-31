package com.developerdan.blocklist.api.configuration;

import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@Configuration
public class DataSourceConfig {
    @Bean
    public DataSource getDataSource() throws IOException {
        var user = System.getenv("POSTGRES_USER");
        var password = Files.readString(Paths.get(System.getenv("POSTGRES_PASSWORD_FILE"))).strip();
        var dataSourceBuilder = DataSourceBuilder.create();
        dataSourceBuilder.username(user);
        dataSourceBuilder.password(password);
        dataSourceBuilder.url("jdbc:postgresql://db:5432/" + user);
        return dataSourceBuilder.build();
    }
}
