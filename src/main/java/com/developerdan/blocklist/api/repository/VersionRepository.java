package com.developerdan.blocklist.api.repository;

import com.developerdan.blocklist.api.entity.Version;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.Collection;
import java.util.UUID;

public interface VersionRepository extends PagingAndSortingRepository<Version, UUID> {
    Page<Version> findByBlocklistIdOrderByLastSeenDesc(UUID blocklistId, Pageable pageable);

    @Query(value = """
                select e.value from version v
                    join entry_period_with_dates ep
                         on ep.start_version_id = v.id
                             or ep.end_version_id = v.id
                             or (
                                    v.created_on >= ep.period_start
                                    and (
                                            ep.period_end is null or
                                            v.created_on <= ep.period_end
                                    )
                            )
                    join entry e on ep.entry_id = e.id
                where v.id = :versionId and v.is_fully_loaded = true
            """, nativeQuery = true
    )
    public Collection<String> findAllEntriesByVersion(UUID versionId);
}
