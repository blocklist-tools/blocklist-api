package com.developerdan.blocklist.api.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.time.Instant;
import java.util.UUID;

@Entity
public class EntryPeriodWithDates {
    @Id
    @Column(insertable = false, updatable = false, nullable = false)
    private UUID id;

    @Column(insertable = false, updatable = false, nullable = false)
    private UUID blocklistId;

    @Column(insertable = false, updatable = false, nullable = false)
    private UUID entryId;

    @Column(insertable = false, updatable = false, nullable = false)
    private UUID startVersionId;

    @Column(insertable = false, updatable = false, nullable = false)
    private UUID endVersionId;

    @Column(insertable = false, updatable = false, nullable = false)
    private Instant periodStart;

    @Column(insertable = false, updatable = false, nullable = false)
    private Instant periodEnd;

    public EntryPeriodWithDates() {
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

    public Instant getPeriodStart() {
        return periodStart;
    }

    public void setPeriodStart(Instant periodStart) {
        this.periodStart = periodStart;
    }

    public Instant getPeriodEnd() {
        return periodEnd;
    }

    public void setPeriodEnd(Instant periodEnd) {
        this.periodEnd = periodEnd;
    }
}
