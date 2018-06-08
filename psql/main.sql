CREATE EXTENSION "pgcrypto" WITH SCHEMA public;
CREATE EXTENSION "uuid-ossp" WITH SCHEMA public;
CREATE EXTENSION "citext" WITH SCHEMA public;

CREATE SCHEMA app_public;
CREATE SCHEMA app_hidden;
CREATE SCHEMA app_private;
SET search_path to app_public, app_private, public;

CREATE TABLE app_private.version (
  id                  serial PRIMARY KEY,
  version             text CHECK (version ~ '^\d+\.\d+\.\d+$') primary key
);
INSERT INTO app_private.version values ('0.0.1');

\ir types.sql
\ir tables/main.sql
\ir functions/main.sql
\ir triggers/main.sql
