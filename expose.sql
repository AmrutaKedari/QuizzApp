-- expose.sql
-- SQLite schema export placeholder for CI/CD
-- Django manages schema via migrations

PRAGMA foreign_keys=OFF;

BEGIN TRANSACTION;

-- Example table (safe placeholder)
CREATE TABLE IF NOT EXISTS ci_health_check (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    status TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ci_health_check (status) VALUES ('OK');

COMMIT;

PRAGMA foreign_keys=ON;