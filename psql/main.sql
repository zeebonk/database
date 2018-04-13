CREATE SCHEMA app_public;
SET search_path to app_public;

CREATE EXTENSION "pgcrypto" with schema app_public;
CREATE EXTENSION "uuid-ossp" with schema app_public;
CREATE EXTENSION "citext" with schema app_public;

CREATE TABLE version (
  version             text CHECK (version ~ '^\d+\.\d+\.\d+$')
);
INSERT INTO version values ('0.0.1');

\ir types.sql
\ir tables/main.sql
\ir functions/main.sql
\ir triggers/main.sql
