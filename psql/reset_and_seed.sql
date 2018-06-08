-- Erase everything from existing DB
DROP SCHEMA IF EXISTS app_public CASCADE;
DROP SCHEMA IF EXISTS app_hidden CASCADE;
DROP SCHEMA IF EXISTS app_private CASCADE;
DROP SCHEMA IF EXISTS app_jobs CASCADE;
DROP EXTENSION IF EXISTS "pgcrypto";
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS "citext";

-- Import the schema again
\ir main.sql

-- Load some sample data
\ir seed.sql

-- Load some sample data
\ir test.sql
