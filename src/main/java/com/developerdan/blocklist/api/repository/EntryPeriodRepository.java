package com.developerdan.blocklist.api.repository;

import com.developerdan.blocklist.api.entity.EntryPeriod;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.Optional;
import java.util.UUID;

public interface EntryPeriodRepository extends PagingAndSortingRepository<EntryPeriod, UUID> {

    @Query(value = """
            select ep.value from entry_period ep
                left join version sv ON ep.start_version_id = sv.id
                where ep.blocklist_id = :blocklistId
                  and ep.entry_id = :entryId
                order by sv.created_on desc
                limit 1
            """, nativeQuery = true
    )
    public Optional<EntryPeriod> findMostRecentByBlocklistIdAndEntryId(UUID blocklistId, UUID entryId);
}
