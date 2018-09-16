CREATE EXTENSION "pgcrypto" WITH SCHEMA public;
CREATE EXTENSION "uuid-ossp" WITH SCHEMA public;
CREATE EXTENSION "citext" WITH SCHEMA public;

CREATE SCHEMA app_public;
CREATE SCHEMA app_hidden;
CREATE SCHEMA app_private;
SET search_path to app_public, app_hidden, app_private, public;
GRANT USAGE ON SCHEMA app_public TO asyncy_visitor;
GRANT USAGE ON SCHEMA app_hidden TO asyncy_visitor;

CREATE TABLE app_private.version (
  version             text CHECK (version ~ '^\d+\.\d+\.\d+$') primary key
);
INSERT INTO app_private.version values ('0.0.1');

\ir types.sql
\ir early_functions/main.sql
\ir tables/main.sql
\ir functions/main.sql
\ir permissions/main.sql
\ir triggers/main.sql
