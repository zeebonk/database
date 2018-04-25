CREATE EXTENSION "pgcrypto" WITH SCHEMA public;
CREATE EXTENSION "uuid-ossp" WITH SCHEMA public;
CREATE EXTENSION "citext" WITH SCHEMA public;

CREATE SCHEMA app_public;
SET search_path to app_public, public;


CREATE TABLE version (
  version             text CHECK (version ~ '^\d+\.\d+\.\d+$') primary key
);
INSERT INTO version values ('0.0.1');

\ir types.sql
\ir tables/main.sql
\ir functions/main.sql
\ir triggers/main.sql
