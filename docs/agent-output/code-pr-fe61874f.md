# Code Generation Proposal — Tutorial Engineering Knowledge Search (Build Stage)

## 1. Summary & Assumptions
- Implement a search-first experience for technical knowledge so engineers can locate documents, procedures, troubleshooting guides, and best practices rapidly, per requirements intake and derived scope.[^1]
- The requirements artifact references a “## UX Mockups (Derived)” section but the shared document had no accessible content during this review; screen flows, layout, and navigation are therefore aligned to the textual feature list and must be validated with stakeholders. **Assumption:** standard search app screens (Search, Results, Result Detail, Admin Content Catalog) match the derived description.
- No seeded content sources or authentication providers were specified; placeholders will be wired to configuration until admins supply values post-build.

## 2. Implementation Plan

### 2.1 UI Layer — Angular + Ionic
- **App shell & routing:** Define high-level routes (`/search`, `/results`, `/details/:id`, `/admin/sources`) with guards prepared for future auth integration.
- **Search workspace:** Reusable components for query input, filter chips, and saved filters panel; respects tunable limits (e.g., max suggestions) sourced from `config/ui.json`.
- **Results list:** Card layout displaying title, snippet, source system, freshness indicator, confidence score; infinite scroll backed by API pagination metadata.
- **Detail view:** Read-only pane with key metadata and deep link button opening the authoritative document in a new tab; include related results sidebar.
- **Admin console:** Table to inspect indexed sources, last sync timestamps, and trigger manual rescan (calls API endpoint).
- **State management:** Use Angular signals or NGXS slice for search criteria, results cache, and user preferences (dark mode flag, default sort).
- **Error & loading UX:** Standardized loading skeletons and toast service reading message catalog in config.

### 2.2 API Layer — FastAPI (Python)
- **Search endpoint (`POST /api/search`)**: Accepts query string, filters, pagination; orchestrates vector/text search providers (abstracted service).
- **Result detail endpoint (`GET /api/results/{result_id}`)**: Returns metadata and source link; caches frequently accessed content using configurable TTL.
- **Admin endpoints:** `GET /api/sources`, `POST /api/sources/{id}/resync` to expose source health and manual sync triggers.
- **Telemetry & auditing:** Middleware capturing search events (user, query hash, timestamp) emitted to message bus placeholder; connection details loaded from config.
- **Validation & error handling:** Pydantic request/response schemas, structured errors with trace IDs.
- **Content connector abstraction:** Interface for searching across repositories (e.g., SharePoint, Confluence); initial implementation uses mocked repository with fixture data until integration details provided.

### 2.3 Database — PostgreSQL
Planned schema (all names derived from project title):

| Table | Purpose | Key fields |
| --- | --- | --- |
| `tek_search_queries` | Persist search events for analytics/audit | `id`, `query_text`, `filters_json`, `executed_at`, `executed_by` |
| `tek_results_cache` | Store cached result metadata for quick lookup | `result_id`, `title`, `summary`, `source_ref`, `score`, `cached_at` |
| `tek_sources` | Track configured knowledge sources and sync state | `id`, `display_name`, `connector_type`, `config_json`, `last_sync_at`, `status` |
| `tek_sync_runs` | Historical log of ingestion jobs | `id`, `source_id`, `started_at`, `completed_at`, `status`, `error_message` |

Migration scripts (Alembic) will create tables plus supporting indexes (GIN on `query_text` for analytics, BTree on timestamps).

### 2.4 Configuration & Secrets
- Extend `/config` folder with environment-scoped JSON: `dev.ui.json`, `dev.api.json`, `dev.db.json`.
- Store tunables such as `search.maxResults`, `results.cacheTtlSeconds`, `ui.snippetLength`, `telemetry.endpoint`, and `connector.defaults`.
- Database credentials, API keys, and message-bus secrets are obtained at runtime from environment variables/managed identity—never committed.
- Application reads merged config at bootstrap; no literal values introduced in code paths.

### 2.5 Dev Experience & Tooling
- **CI/CD hooks:** GitHub Actions workflow to run lint (`ng lint`, `ruff`), unit tests, and publish Docker images tagged `dev`.
- **Testing scaffolds:** Jest + Spectator for Angular components; PyTest for FastAPI services with database fixtures via `pytest-postgresql`.
- **Data seeding:** Non-sensitive seed script that inserts placeholder sources and sample indexed documents for dev/test.

## 3. Testing Strategy
1. **Unit tests**
   - UI: component rendering, filter state transitions, service mocks for API calls.
   - API: request validation, search service orchestration, connector fallbacks, admin resync command.
   - DB: repository classes with transactional rollback fixtures.
2. **Integration tests**
   - End-to-end search flow using Prisma-like fixtures (FastAPI TestClient + seeded PostgreSQL).
   - Admin resync triggering mock connector job.
3. **Contract tests**
   - OpenAPI schema snapshot validated against UI client to detect breaking changes.
4. **Performance smoke**
   - Locust or k6 scripts (configurable concurrency) verifying search endpoint latency under representative load.
5. **Accessibility & UX checks**
   - Lighthouse CI budget for contrast, keyboard navigation, and semantic markup compliance.

## 4. Risks, Mitigations, and Open Questions
| Risk / Gap | Impact | Mitigation / Next Step |
| --- | --- | --- |
| Missing authoritative UX specifications | Potential rework if derived layouts differ from stakeholder expectations | Present wireframe preview early; adjust once official “UX Mockups (Derived)” section becomes available. |
| Unspecified content connectors & authentication | Could block integration with real sources | Build connector interface with mock provider; document required credentials and mapping fields for future integration. |
| Search relevance tuning requires real corpus | Demo quality may suffer with placeholder data | Introduce configurable ranking weights and logging to speed calibration once actual corpora provided. |
| Auditing requirements undefined | Compliance gaps if expectations differ | Define audit event payloads and retention rules with stakeholders before release. |

---

[^1]: Requirements Agent summary referencing the `tutorial-engineering-knowledge-search-requirements.md` intake record on the project SharePoint workspace.