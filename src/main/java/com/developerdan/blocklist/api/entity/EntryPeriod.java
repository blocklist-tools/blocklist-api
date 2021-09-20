package com.developerdan.blocklist.api.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.util.UUID;

@Entity
public class EntryPeriod {
    @Id
    @GeneratedValue()
    @Column(updatable = false, nullable = false)
    private UUID id;

    @Column(updatable = false, nullable = false)
    private UUID blocklistId;

    @Column(updatable = false, nullable = false)
    private UUID entryId;

    @Column(nullable = false)
    private UUID startVersionId;

    @Column
    private UUID endVersionId;

    public EntryPeriod(UUID blocklistId, UUID entryId, UUID startVersionId) {
        this.blocklistId = blocklistId;
        this.entryId = entryId;
        this.startVersionId = startVersionId;
    }

    public EntryPeriod() {
        // bean
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getBlocklistId() {
        return blocklistId;
    }

    public void setBlocklistId(UUID blocklistId) {
        this.blocklistId = blocklistId;
    }

    public UUID getEntryId() {
        return entryId;
    }

    public void setEntryId(UUID entryId) {
        this.entryId = entryId;
    }

    public UUID getStartVersionId() {
        return startVersionId;
    }

    public void setStartVersionId(UUID startVersionId) {
        this.startVersionId = startVersionId;
    }

    public UUID getEndVersionId() {
        return endVersionId;
    }

    public void setEndVersionId(UUID endVersionId) {
        this.endVersionId = endVersionId;
    }
}
