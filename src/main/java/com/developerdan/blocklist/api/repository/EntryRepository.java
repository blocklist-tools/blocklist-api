package com.developerdan.blocklist.api.repository;

import com.developerdan.blocklist.api.entity.Entry;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.Optional;
import java.util.UUID;

public interface EntryRepository extends PagingAndSortingRepository<Entry, UUID> {
    public Optional<Entry> findByValue(String value);
}
