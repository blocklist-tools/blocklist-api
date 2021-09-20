package com.developerdan.blocklist.api.entity;

import org.hibernate.validator.constraints.Length;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.validation.constraints.Min;
import java.time.Instant;
import java.util.UUID;

@Entity
public class Version {
    @Id
    @GeneratedValue()
    @Column(updatable = false, nullable = false)
    private UUID id;

    @Column(updatable = false, nullable = false)
    private UUID blocklistId;

    @Column(nullable = false)
    @Min(0)
    private long numEntries;

    @Column(updatable = false, nullable = false)
    @Length(min = 1, max = 255)
    private String rawSha256;

    @Column(nullable = false)
    @Length(min = 1, max = 255)
    private String parsedSha256;

    @Column(nullable = false, updatable = false)
    private Instant createdOn;

    @Column(nullable = false)
    private Instant lastSeen;

    @Column(nullable = false)
    private boolean isFullyLoaded;

    public Version() {
        // bean
    }

    public Version(Blocklist blocklist) {
        this.blocklistId = blocklist.getId();
    }

    public void update(Version updatedVersion) {
        this.lastSeen = updatedVersion.lastSeen;
        this.numEntries = updatedVersion.numEntries;
        this.isFullyLoaded = updatedVersion.isFullyLoaded;
        this.parsedSha256 = updatedVersion.parsedSha256;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public long getNumEntries() {
        return numEntries;
    }

    public void setNumEntries(long entries) {
        this.numEntries = entries;
    }

    public String getRawSha256() {
        return rawSha256;
    }

    public void setRawSha256(String rawSha256) {
        this.rawSha256 = rawSha256;
    }

    public String getParsedSha256() {
        return parsedSha256;
    }

    public void setParsedSha256(String parsedSha256) {
        this.parsedSha256 = parsedSha256;
    }

    public Instant getCreatedOn() {
        return createdOn;
    }

    public void setCreatedOn(Instant createdOn) {
        this.createdOn = createdOn;
    }

    public Instant getLastSeen() {
        return lastSeen;
    }

    public void setLastSeen(Instant lastSeen) {
        this.lastSeen = lastSeen;
    }

    public UUID getBlocklistId() {
        return blocklistId;
    }

    public boolean isFullyLoaded() {
        return isFullyLoaded;
    }

    public void setFullyLoaded(boolean fullyLoaded) {
        isFullyLoaded = fullyLoaded;
    }
}
