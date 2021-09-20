package com.developerdan.blocklist.api.entity;

import com.developerdan.blocklist.tools.Domain;
import org.hibernate.validator.constraints.Length;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.util.UUID;

@Entity
public class Entry {
    @Id
    @GeneratedValue()
    @Column(updatable = false, nullable = false)
    private UUID id;

    @Column(updatable = false, nullable = false, unique = true)
    @Length(min = 1, max = 255)
    private String value;

    public static Entry fromDomain(Domain domain) {
        return new Entry(domain.toString());
    }

    public Entry(String value) {
        this.value = value;
    }

    public Entry() {
        // bean
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
