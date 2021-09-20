package com.developerdan.blocklist.api.responses;

import java.util.Collection;

public class EntrySearchResponse {
    private String query;
    private Collection<EntrySummary> summaries;

    public EntrySearchResponse(String query, Collection<EntrySummary> summaries) {
        this.query = query;
        this.summaries = summaries;
    }

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public Collection<EntrySummary> getSummaries() {
        return summaries;
    }

    public void setSummaries(Collection<EntrySummary> summaries) {
        this.summaries = summaries;
    }
}
