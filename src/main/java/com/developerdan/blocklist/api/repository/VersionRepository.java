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
                join entry_period ep
                    on ep.start_version_id = v.id
                    or (
                        ep.period_start <= v.created_on
                        and ep.end_version_id != v.id
                        and (
                            ep.period_end > v.created_on
                            or ep.period_end is null
                        )
                    )
                join entry e on ep.entry_id = e.id
                where v.id = :versionId""", nativeQuery = true
    )
    public Collection<String> findAllEntriesByVersion(UUID versionId);
}
