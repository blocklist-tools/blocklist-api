package com.developerdan.blocklist.api.entity;

import org.hibernate.validator.constraints.Length;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.util.UUID;

@Entity
public class Blocklist {
    @Id
    @GeneratedValue()
    @Column(updatable = false, nullable = false)
    private UUID id;

    @Column(nullable = false)
    @Length(min = 1, max = 255)
    private String name;

    @Column(updatable = false, nullable = false)
    @Length(min = 1, max = 255)
    private String format;

    @Column(nullable = false)
    @Length(min = 1, max = 255)
    private String downloadUrl;

    @Column(nullable = false)
    @Length(min = 1, max = 255)
    private String homepageUrl;

    @Column(nullable = false)
    @Length(min = 1, max = 255)
    private String issuesUrl;

    @Column
    @Length(max = 255)
    private String licenseUrl;

    @Column(nullable = false)
    @Length(min = 1, max = 255)
    private String licenseType;

    public Blocklist() {
        // bean
    }

    public void update(Blocklist newVersion) {
        this.name = newVersion.name;
        this.downloadUrl = newVersion.downloadUrl;
        this.homepageUrl = newVersion.homepageUrl;
        this.issuesUrl = newVersion.issuesUrl;
        this.licenseUrl = newVersion.licenseUrl;
        this.licenseType = newVersion.licenseType;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

    public String getDownloadUrl() {
        return downloadUrl;
    }

    public void setDownloadUrl(String downloadUrl) {
        this.downloadUrl = downloadUrl;
    }

    public String getHomepageUrl() {
        return homepageUrl;
    }

    public void setHomepageUrl(String homepageUrl) {
        this.homepageUrl = homepageUrl;
    }

    public String getIssuesUrl() {
        return issuesUrl;
    }

    public void setIssuesUrl(String issuesUrl) {
        this.issuesUrl = issuesUrl;
    }

    public String getLicenseUrl() {
        return licenseUrl;
    }

    public void setLicenseUrl(String licenseUrl) {
        this.licenseUrl = licenseUrl;
    }

    public String getLicenseType() {
        return licenseType;
    }

    public void setLicenseType(String licenseType) {
        this.licenseType = licenseType;
    }
}
