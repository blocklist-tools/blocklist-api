package com.developerdan.blocklist.api;

import com.developerdan.blocklist.api.configuration.AppConfig;
import com.developerdan.blocklist.api.entity.Blocklist;
import com.developerdan.blocklist.api.entity.Entry;
import com.developerdan.blocklist.api.entity.EntryPeriod;
import com.developerdan.blocklist.api.entity.Version;
import com.developerdan.blocklist.api.repository.BlocklistRepository;
import com.developerdan.blocklist.api.repository.EntryPeriodRepository;
import com.developerdan.blocklist.api.repository.EntryRepository;
import com.developerdan.blocklist.api.repository.VersionRepository;
import com.developerdan.blocklist.api.responses.DomainResponse;
import com.developerdan.blocklist.api.responses.EntrySearchResponse;
import com.developerdan.blocklist.tools.DnsQuery;
import com.developerdan.blocklist.tools.DnsResponse;
import com.developerdan.blocklist.tools.Domain;
import com.developerdan.blocklist.tools.ListDiff;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.Instant;
import java.util.List;
import java.util.NavigableSet;
import java.util.Optional;
import java.util.TreeSet;
import java.util.UUID;
import java.util.stream.Collectors;

@SpringBootApplication
@RestController
@CrossOrigin(origins = {"http://localhost:3000"})
public class BlocklistApiApplication {

	private static final String AUTH_HEADER_NAME = "Authorization-Token";
	private static final Logger LOGGER = LoggerFactory.getLogger(BlocklistApiApplication.class);
	private static final int PAGE_SIZE = 100;

	@Autowired
	private BlocklistRepository blocklistRepository;
	@Autowired
	private VersionRepository versionRepository;
	@Autowired
	private EntryRepository entryRepository;
	@Autowired
	private EntryPeriodRepository entryPeriodRepository;

	public static void main(String[] args) {
		SpringApplication.run(BlocklistApiApplication.class, args);
	}

	@GetMapping("/dns-query")
	public ResponseEntity<DnsResponse> dnsQuery(@RequestParam(value = "name") String name,
												@RequestParam(value = "type") String type) {
		try {
			DnsQuery.resolvers(AppConfig.dnsServers());
			var domain = Domain.fromString(name).orElseThrow();
			var queryResponse = DnsQuery.dig(domain, type);
			return ResponseEntity.ok()
					.headers(buildCacheHeaders(3600)) // 1 hour
					.body(queryResponse);
		} catch (IllegalArgumentException ex) {
			LOGGER.error("{} Error, {}: {}", ex.getClass(), ex.getMessage(), ex.getStackTrace());
			return ResponseEntity.unprocessableEntity().build();
		} catch (IOException ex) {
			LOGGER.error("{} Error, {}: {}", ex.getClass(), ex.getMessage(), ex.getStackTrace());
			return new ResponseEntity<>(HttpStatus.SERVICE_UNAVAILABLE);
		}
	}

	@GetMapping("/entries/search")
	public ResponseEntity<EntrySearchResponse> entrySearch(@RequestParam(value = "q") String query) {
		var domain = Domain.fromString(query).orElseThrow();
		var summaries = blocklistRepository.findAllSummariesByEntry(domain.toString());
		var response = new EntrySearchResponse(domain.toString(), summaries);
		return ResponseEntity.ok()
				.headers(buildCacheHeaders(43200)) // 6 hours
				.body(response);
	}

	@GetMapping("/blocklists")
	public ResponseEntity<List<Blocklist>> getBlocklists(@RequestParam(defaultValue = "0") int page) {
		var blocklists = blocklistRepository.findAll(PageRequest.of(page, PAGE_SIZE)).getContent();
		return ResponseEntity.ok()
				.headers(buildCacheHeaders(43200)) // 12 hours
				.body(blocklists);
	}

	@GetMapping("/blocklists/{blocklistId}")
	public Optional<Blocklist> getBlocklist(@PathVariable(value = "blocklistId") UUID blocklistId) {
		return blocklistRepository.findById(blocklistId);
	}

	@GetMapping("/blocklists/{blocklistId}/versions")
	public ResponseEntity<List<Version>> getVersions(@PathVariable(value = "blocklistId") UUID blocklistId,
													 @RequestParam(defaultValue = "0") int page) {
		var versions = versionRepository.findByBlocklistIdOrderByLastSeenDesc(blocklistId, PageRequest.of(page, PAGE_SIZE)).getContent();
		return ResponseEntity.ok()
				.headers(buildCacheHeaders(43200)) // 12 hours
				.body(versions);
	}

	@PostMapping("/versions")
	public ResponseEntity<Version> createVersion(@RequestHeader(value = AUTH_HEADER_NAME) String authToken,
												 @Validated @RequestBody Version version) {
		assertAuthenticated(authToken, "createVersion");
		version.setFullyLoaded(false);
		if (version.getCreatedOn() == null) {
			var now = Instant.now();
			version.setCreatedOn(now);
			version.setLastSeen(now);
		}
		if (version.getLastSeen() == null) {
			version.setLastSeen(version.getCreatedOn());
		}
		return new ResponseEntity<>(versionRepository.save(version), HttpStatus.CREATED);
	}

	@PutMapping("/versions")
	public ResponseEntity<Version> updateVersion(@RequestHeader(value = AUTH_HEADER_NAME) String authToken,
												 @Validated @RequestBody Version version) {
		assertAuthenticated(authToken, "updateVersion");
		var existingVersion = versionRepository.findById(version.getId()).orElseThrow();
		existingVersion.update(version);
		return new ResponseEntity<>(versionRepository.save(existingVersion), HttpStatus.OK);
	}

	@DeleteMapping("/versions/{versionId}")
	public ResponseEntity<Void> deleteVersion(@RequestHeader(value = AUTH_HEADER_NAME) String authToken,
											  @PathVariable(value = "versionId") UUID versionId) {
		assertAuthenticated(authToken, "deleteVersion");
		versionRepository.deleteById(versionId);
		return ResponseEntity.ok().body(null);
	}

	@GetMapping("/versions/{versionId}/entries")
	public ResponseEntity<String> getEntries(@RequestHeader(value = AUTH_HEADER_NAME) String authToken,
																 @PathVariable(value = "versionId") UUID versionId) {
		assertAuthenticated(authToken, "getEntries");
		var entries = versionRepository.findAllEntriesByVersion(versionId);
		var domains = entries.stream().parallel()
												.map(Domain::fromString)
												.map(Optional::get)
												.map(DomainResponse::fromDomain)
												.collect(Collectors.toCollection(TreeSet::new));

		return ResponseEntity.ok()
				.headers(buildCacheHeaders(31536000)) // 1 year
				.body(domains.stream()
						.map(DomainResponse::toString)
						.collect(Collectors.joining("\n"))
						+ "\n"
				);
	}

	@GetMapping("/versions/{baseVersion}/diff")
	public ResponseEntity<String> diff(@PathVariable(value = "baseVersion") UUID secondVersion) {
		var baseVersion = versionRepository.getVersionBefore(secondVersion);
		return diff(baseVersion.getId(), secondVersion);
	}

	@GetMapping("/versions/{baseVersion}/diff/{newVersion}")
	public ResponseEntity<String> diff(@PathVariable(value = "baseVersion") UUID baseVersion,
									   @PathVariable(value = "newVersion") UUID newVersion) {
		NavigableSet<Domain> firstList = versionRepository
				.findAllEntriesByVersion(baseVersion)
				.parallelStream()
				.map(Domain::fromString)
				.filter(Optional::isPresent)
				.map(Optional::get)
				.collect(Collectors.toCollection(TreeSet::new));
		NavigableSet<Domain> secondList = versionRepository
				.findAllEntriesByVersion(newVersion)
				.parallelStream()
				.map(Domain::fromString)
				.filter(Optional::isPresent)
				.map(Optional::get)
				.collect(Collectors.toCollection(TreeSet::new));

		var diff = ListDiff.domainList(firstList, secondList);
		return ResponseEntity.ok()
				.headers(buildCacheHeaders(2629800)) // 1 month
				.body(diff);
	}

	@PostMapping("/blocklists/{blocklistId}/versions/{versionId}/entries")
	public ResponseEntity<Void> startEntryPeriod(@RequestHeader(value = AUTH_HEADER_NAME) String authToken,
											     @PathVariable(value = "blocklistId") UUID blocklistId,
										 		 @PathVariable(value = "versionId") UUID firstIncludedVersion,
												 @Validated @RequestBody String entryValue) {
		assertAuthenticated(authToken, "startEntryPeriod");
		var domain = Domain.fromString(entryValue).orElseThrow();
		var entry = loadOrCreateEntry(domain);
		var entryPeriod = new EntryPeriod(blocklistId, entry.getId(), firstIncludedVersion);
		entryPeriodRepository.save(entryPeriod);
		return ResponseEntity.status(201).build();
	}

	@PutMapping("/blocklists/{blocklistId}/versions/{lastVersionId}/entries")
	public ResponseEntity<Void> endEntryPeriod(@RequestHeader(value = AUTH_HEADER_NAME) String authToken,
											   @PathVariable(value = "blocklistId") UUID blocklistId,
											   @PathVariable(value = "lastVersionId") UUID lastIncludedVersionId,
											   @Validated @RequestBody String entryValue) {
		assertAuthenticated(authToken, "endEntryPeriod");
		var domain = Domain.fromString(entryValue).orElseThrow();
		var entry = loadOrCreateEntry(domain);
		var entryPeriod = entryPeriodRepository.findMostRecentByBlocklistIdAndEntryId(blocklistId, entry.getId()).orElseThrow();
		entryPeriod.setEndVersionId(lastIncludedVersionId);
		entryPeriodRepository.save(entryPeriod);
		return ResponseEntity.status(201).build();
	}

	private Entry loadOrCreateEntry(Domain domain) {
		var optionalEntry = entryRepository.findByValue(domain.toString());
		return optionalEntry.orElseGet(() -> entryRepository.save(Entry.fromDomain(domain)));
	}

	private HttpHeaders buildCacheHeaders(int seconds) {
		var responseHeaders = new HttpHeaders();
		responseHeaders.set("Cache-Control",
				"public, max-age=" + seconds + ", immutable");
		return responseHeaders;
	}

	private void assertAuthenticated(String header, String resourceName) {
		if (!AppConfig.authToken().equals(header)) {
			LOGGER.warn("Unauthenticated access attempt to {}: {}", resourceName, header);
			throw new SecurityException("Invalid or missing API Token for " + resourceName + "!");
		}
	}
}
