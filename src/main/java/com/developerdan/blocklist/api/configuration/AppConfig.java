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

    private static String[] dnsServers;

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

    public static String[] dnsServers()  {
        if (dnsServers == null) {
            dnsServers = loadDnsServers();
        }
        return dnsServers;
    }

    private static String[] loadDnsServers() {
        var dnsServers = System.getenv("DNS_SERVERS");
        if (dnsServers == null || dnsServers.isBlank()) {
            LOGGER.error("Unable to read DNS_SERVERS");
            dnsServers = "";
        }
        return dnsServers.split("\\s*,\\s*");
    }
}
