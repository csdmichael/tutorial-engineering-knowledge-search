# Delivery plan — Tutorial Engineering Knowledge Search

Sprints are two weeks. Each sprint closes with a demo and an approval gate.

| Sprint | Focus | Exit criteria |
| --- | --- | --- |
| Sprint 1 | Foundation: repo, pipelines, schema | CI green, API deployed |
| Sprint 2 | Core scope | Approved user stories delivered |
| Sprint 3 | Hardening and release | Tests pass, release gate approved |

## Approved scope

- Implement a search-first experience for technical knowledge so engineers can locate documents, procedures, troubleshooting guides, and best practices rapidly, per requirements intake and derived scope.[^1]
- The requirements artifact references a “## UX Mockups (Derived)” section but the shared document had no accessible content during this review; screen flows, layout, and navigation are therefore aligned to the textual feature list and must be validated with stakeholders. **Assumption:** standard search app screens (Search, Results, Result Detail, Admin Content Catalog) match the derived description.
- No seeded content sources or authentication providers were specified; placeholders will be wired to configuration until admins supply values post-build.
- **App shell & routing:** Define high-level routes (`/search`, `/results`, `/details/:id`, `/admin/sources`) with guards prepared for future auth integration.
- **Search workspace:** Reusable components for query input, filter chips, and saved filters panel; respects tunable limits (e.g., max suggestions) sourced from `config/ui.json`.
- **Results list:** Card layout displaying title, snippet, source system, freshness indicator, confidence score; infinite scroll backed by API pagination metadata.
- **Detail view:** Read-only pane with key metadata and deep link button opening the authoritative document in a new tab; include related results sidebar.
- **Admin console:** Table to inspect indexed sources, last sync timestamps, and trigger manual rescan (calls API endpoint).
- **State management:** Use Angular signals or NGXS slice for search criteria, results cache, and user preferences (dark mode flag, default sort).
- **Error & loading UX:** Standardized loading skeletons and toast service reading message catalog in config.
- **Search endpoint (`POST /api/search`)**: Accepts query string, filters, pagination; orchestrates vector/text search providers (abstracted service).
- **Result detail endpoint (`GET /api/results/{result_id}`)**: Returns metadata and source link; caches frequently accessed content using configurable TTL.
