-- Forward-only migration 0002: reference data so a new environment is not empty.
-- Re-runnable: each row is inserted only when its title is absent.
INSERT INTO search (title, reference, status, priority)
SELECT 'Sample Search 1', 'S-0001', 'new', 'low'
WHERE NOT EXISTS (SELECT 1 FROM search WHERE title = 'Sample Search 1');
INSERT INTO search (title, reference, status, priority)
SELECT 'Sample Search 2', 'S-0002', 'in-progress', 'normal'
WHERE NOT EXISTS (SELECT 1 FROM search WHERE title = 'Sample Search 2');
INSERT INTO search (title, reference, status, priority)
SELECT 'Sample Search 3', 'S-0003', 'complete', 'high'
WHERE NOT EXISTS (SELECT 1 FROM search WHERE title = 'Sample Search 3');
INSERT INTO search (title, reference, status, priority)
SELECT 'Sample Search 4', 'S-0004', 'new', 'low'
WHERE NOT EXISTS (SELECT 1 FROM search WHERE title = 'Sample Search 4');
