# API contracts — Tutorial Engineering Knowledge Search

The OpenAPI document is the authoritative contract: Swagger UI at `/docs`, raw document at `/openapi.json`. This table is the summary.

| Method | Path | Purpose | Response |
| --- | --- | --- | --- |
| `GET` | `/health` | Liveness probe used by the deploy pipeline | `{"status": "ok"}` |
| `GET` | `/api/searches` | List searches; `?status=` filters | `Search[]` |
| `POST` | `/api/searches` | Create a search | `201` + `Search` |
| `GET` | `/api/searches/{id}` | Fetch one search | `Search` or `404` |
| `PATCH` | `/api/searches/{id}` | Partial update | `Search` or `404` |
| `DELETE` | `/api/searches/{id}` | Remove a search | `204` or `404` |

## `Search`

| Field | Type | Notes |
| --- | --- | --- |
| `id` | integer | Server assigned |
| `title` | string | Required, 1–400 characters |
| `reference` | string | Optional, up to 200 characters |
| `status` | enum | `new`, `in-progress`, `complete` |
| `priority` | enum | `low`, `normal`, `high` |
