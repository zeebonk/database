DROP SCHEMA IF EXISTS app_public CASCADE;
DROP SCHEMA IF EXISTS app_private CASCADE;
DROP SCHEMA IF EXISTS app_hidden CASCADE;
DROP SCHEMA IF EXISTS app_jobs CASCADE;

DROP EXTENSION IF EXISTS "pgcrypto";
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS "citext";

DROP ROLE IF EXISTS asyncy_visitor;
DO $$
BEGIN
  IF EXISTS(SELECT 1 FROM pg_roles WHERE rolname = 'asyncy_authenticator') THEN
    REVOKE CONNECT ON DATABASE asyncy FROM asyncy_authenticator;
  END IF;
END;
$$ LANGUAGE plpgsql;
DROP ROLE IF EXISTS asyncy_authenticator;

CREATE ROLE asyncy_authenticator WITH LOGIN PASSWORD 'PLEASE_CHANGE_ME' NOINHERIT;
CREATE ROLE asyncy_visitor;
GRANT asyncy_visitor to asyncy_authenticator;

REVOKE ALL ON DATABASE asyncy FROM PUBLIC;
GRANT CONNECT ON DATABASE asyncy TO asyncy_authenticator;

---

BEGIN;
\ir ./main.sql
COMMIT;
