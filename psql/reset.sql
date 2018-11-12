DROP SCHEMA IF EXISTS app_runtime CASCADE;
DROP SCHEMA IF EXISTS app_public CASCADE;
DROP SCHEMA IF EXISTS app_private CASCADE;
DROP SCHEMA IF EXISTS app_hidden CASCADE;
DROP SCHEMA IF EXISTS app_jobs CASCADE;

DROP EXTENSION IF EXISTS "pgcrypto";
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS "citext";

REVOKE ALL ON DATABASE asyncy FROM PUBLIC;

DO $$
BEGIN
  IF NOT EXISTS(SELECT 1 FROM pg_roles WHERE rolname = 'asyncy_authenticator') THEN
    CREATE ROLE asyncy_authenticator WITH LOGIN PASSWORD 'PLEASE_CHANGE_ME' NOINHERIT;
  END IF;
  IF NOT EXISTS(SELECT 1 FROM pg_roles WHERE rolname = 'asyncy_visitor') THEN
    CREATE ROLE asyncy_visitor;
  END IF;
END;
$$ LANGUAGE plpgsql;
GRANT asyncy_visitor to asyncy_authenticator;
GRANT CONNECT ON DATABASE asyncy TO asyncy_authenticator;

---

\ir ./main.sql
