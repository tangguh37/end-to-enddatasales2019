-- Step 1: Check logical replication status
SHOW wal_level;

-- Step 2: Create a dedicated replication user (run as superuser)
CREATE ROLE streamkap_user WITH REPLICATION LOGIN PASSWORD 'your_strong_password_here';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO streamkap_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO streamkap_user;

-- Step 3: Create a publication for the sales table
CREATE PUBLICATION streamkap_pub FOR TABLE sales;

-- Step 4: Verify publication
SELECT * FROM pg_publication;
SELECT * FROM pg_publication_tables;

-- IMPORTANT: Use direct (non-pooled) connection in Streamkap.
-- Neon pooled connections (PgBouncer) do NOT support the replication protocol.
-- Remove '-pooler' from your Neon hostname when configuring Streamkap.
