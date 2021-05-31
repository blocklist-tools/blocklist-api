package com.developerdan.blocklist.api.responses;

import com.developerdan.blocklist.tools.Domain;
import com.fasterxml.jackson.annotation.JsonValue;

public class DomainResponse implements Comparable<DomainResponse>  {
    private final Domain domain;

    private DomainResponse(Domain domain) {
        this.domain = domain;
    }

    public static DomainResponse fromDomain(Domain domain) {
        return new DomainResponse(domain);
    }

    public Domain getDomain() {
        return domain;
    }

    @Override
    @JsonValue
    public String toString() {
        return domain.toString();
    }

    @Override
    public boolean equals(Object other) {
        return domain.equals(other);
    }

    @Override
    public int hashCode() {
        return domain.hashCode();
    }

    @Override
    public int compareTo(DomainResponse other) {
        return this.domain.compareTo(other.getDomain());
    }
}
