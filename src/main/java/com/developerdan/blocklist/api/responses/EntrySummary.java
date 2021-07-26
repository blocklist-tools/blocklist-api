package com.developerdan.blocklist.api.responses;

import java.time.Instant;

public interface EntrySummary {
    String getBlocklistName();
    String getBlocklistId();
    String getAddedVersionId();
    Instant getAddedOn();
    String getRemovedVersionId();
    Instant getRemovedOn();
    String getListAddedOn();
}
