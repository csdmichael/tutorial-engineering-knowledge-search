-- Tutorial Engineering Knowledge Search — consolidated schema (PostgreSQL)
CREATE TABLE IF NOT EXISTS search (
    id           BIGSERIAL PRIMARY KEY,
    title        TEXT        NOT NULL,
    reference    TEXT        NOT NULL DEFAULT '',
    status       TEXT        NOT NULL DEFAULT 'new',
    priority     TEXT        NOT NULL DEFAULT 'normal',
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
