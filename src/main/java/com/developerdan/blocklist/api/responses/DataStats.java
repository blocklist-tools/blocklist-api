package com.developerdan.blocklist.api.responses;

public interface DataStats {
    Integer getVersions();
    Integer getBlocklists();
    Long getDomains();
    Long getEntries();
    String getSize();
}
