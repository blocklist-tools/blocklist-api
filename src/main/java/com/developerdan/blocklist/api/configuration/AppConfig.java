package com.developerdan.blocklist.api.configuration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class AppConfig {

    private static final Logger LOGGER = LoggerFactory.getLogger(AppConfig.class);

    private static String authToken;

    private AppConfig() {

    }

    public static String authToken()  {
        if (authToken == null) {
            authToken = loadAuthToken();
        }
        return authToken;
    }

    private static String loadAuthToken() throws UncheckedIOException {
        try {
            return Files.readString(Paths.get(System.getenv("AUTH_TOKEN_FILE"))).strip();
        } catch (IOException ex) {
            LOGGER.error("Unable to read AUTH_TOKEN_FILE", ex);
            throw new UncheckedIOException("Unable to read AUTH_TOKEN_FILE", ex);
        }
    }

    public static List<String> corsOrigins() {
        var corsOrigins = System.getenv("CORES_ORIGINS");
        if (corsOrigins == null || corsOrigins.isBlank()) {
            return new ArrayList<>();
        }
        return Arrays.asList(corsOrigins.split("\\s*,\\s*"));
    }
}
