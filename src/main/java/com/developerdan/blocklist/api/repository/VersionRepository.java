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
                         on ep.blocklist_id = v.blocklist_id
                         and (ep.start_version_id = v.id
                             or ep.end_version_id = v.id
                             or (
                                    v.created_on >= ep.period_start
                                    and (
                                            ep.period_end is null or
                                            v.created_on <= ep.period_end
                                    )
                            ))
                    join entry e on ep.entry_id = e.id
                where v.id = :versionId and v.is_fully_loaded = true
            """, nativeQuery = true
    )
    public Collection<String> findAllEntriesByVersion(UUID versionId);

    @Query(value = """
            select v.*
                        from version v
                        join (select created_on, blocklist_id from version where id = :versionId) as current_version
                        on v.blocklist_id = current_version.blocklist_id
                        and v.created_on < current_version.created_on
                        order by v.created_on desc
                        limit 1
            """, nativeQuery = true
    )
    public Version getVersionBefore(UUID versionId);
}
