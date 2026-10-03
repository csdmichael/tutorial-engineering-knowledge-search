# Tutorial Engineering Knowledge Search — API

FastAPI service. Owns validation, authorization, and all database access.

| Path | Purpose |
| --- | --- |
| `/health` | Liveness probe |
| `/docs` | Swagger UI |
| `/openapi.json` | OpenAPI document |
| `/api/searches` | Searches collection (GET, POST) |
| `/api/searches/{id}` | Single search (GET, PATCH, DELETE) |
