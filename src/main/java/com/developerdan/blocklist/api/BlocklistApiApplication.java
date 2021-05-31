package com.developerdan.blocklist.api;

import com.developerdan.blocklist.api.configuration.AppConfig;
import com.developerdan.blocklist.api.entity.Blocklist;
import com.developerdan.blocklist.api.entity.Version;
import com.developerdan.blocklist.api.repository.BlocklistRepository;
import com.developerdan.blocklist.api.repository.VersionRepository;
import com.developerdan.blocklist.api.responses.DomainResponse;
import com.developerdan.blocklist.tools.Domain;
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

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.TreeSet;
import java.util.UUID;
import java.util.stream.Collectors;

@SpringBootApplication
@RestController
@CrossOrigin(origins = {"https://blocklist-tools.developerdan.com"})
public class BlocklistApiApplication {

	private static final String AUTH_HEADER_NAME = "Authorization-Token";
	private static final Logger LOGGER = LoggerFactory.getLogger(BlocklistApiApplication.class);
	private static final int PAGE_SIZE = 100;

	@Autowired
	private BlocklistRepository blocklistRepository;
	@Autowired
	private VersionRepository versionRepository;

	public static void main(String[] args) {
		SpringApplication.run(BlocklistApiApplication.class, args);
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
	public ResponseEntity<Collection<DomainResponse>> getEntries(@RequestHeader(value = AUTH_HEADER_NAME) String authToken,
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
				.body(domains);
	}

	private HttpHeaders buildCacheHeaders(int seconds) {
		var responseHeaders = new HttpHeaders();
		responseHeaders.set("Cache-Control",
				"public, max-age=" + seconds + ", immutable");
		return responseHeaders;
	}

	private void assertAuthenticated(String header, String resourceName) {
		if (!AppConfig.authToken().equals(header)) {
			LOGGER.warn("Unauthenticated access attempt to {}", resourceName);
			throw new SecurityException("Invalid or missing API Token!");
		}
	}
}
