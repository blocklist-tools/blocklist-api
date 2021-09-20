package com.developerdan.blocklist.api.repository;

import com.developerdan.blocklist.api.entity.EntryPeriod;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.Optional;
import java.util.UUID;

public interface EntryPeriodRepository extends PagingAndSortingRepository<EntryPeriod, UUID> {

    @Query(value = """
            select ep.* from entry_period ep
                join version sv ON ep.start_version_id = sv.id and sv.is_fully_loaded is true
                join entry e on ep.entry_id = e.id
                where ep.blocklist_id = :blocklistId
                  and e.value = :entryValue
                order by sv.created_on desc
                limit 1
            """, nativeQuery = true
    )
    public Optional<EntryPeriod> findMostRecentByBlocklistIdAndEntryValue(UUID blocklistId, String entryValue);
}
