package com.developerdan.blocklist.api.repository;

import com.developerdan.blocklist.api.entity.Blocklist;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.UUID;

public interface BlocklistRepository extends PagingAndSortingRepository<Blocklist, UUID> {

}
