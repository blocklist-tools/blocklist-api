package com.developerdan.blocklist.api.repository;

import com.developerdan.blocklist.api.entity.Blocklist;
import com.developerdan.blocklist.api.responses.EntrySummary;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.Collection;
import java.util.UUID;

public interface BlocklistRepository extends PagingAndSortingRepository<Blocklist, UUID> {
    @Query(value = """
            select cast(epwd.blocklist_id as varchar)                                           as blocklistId,
                   cast(epwd.start_version_id as varchar)                                       as addedVersionId,
                   cast(epwd.end_version_id as varchar)                                         as removedVersionId,
                   epwd.period_end                                                              as removedOn,
                   epwd.period_start                                                            as addedOn,
                   (select min(created_on) from version where blocklist_id = epwd.blocklist_id) as listAddedOn,
                   (select name from blocklist where id = epwd.blocklist_id)                    as blocklistName,
                   case
                        when epwd.period_end is null then 0
                        else 1
                   end as stillBlocked
            from entry_period_with_dates epwd
                     join entry on epwd.entry_id = entry.id
            where entry.value = :query
              and epwd.period_start = (
                select max(period_start)
                from entry_period_with_dates
                where blocklist_id = epwd.blocklist_id
                  and entry_id = epwd.entry_id
            )
            order by stillBlocked, addedOn
            """, nativeQuery = true
    )
    Collection<EntrySummary> findAllSummariesByEntry(String query);
}
