<<<<<<< Updated upstream
create schema if not exists app_public;
set search_path to app_public;

create extension if not exists "pgcrypto" with schema app_public;
create extension if not exists "uuid-ossp" with schema app_public;
create extension if not exists "citext" with schema app_public;
=======
CREATE SCHEMA app_public;
SET search_path to app_public;

CREATE EXTENSION "pgcrypto" with schema app_public;
CREATE EXTENSION "uuid-ossp" with schema app_public;
CREATE EXTENSION "citext" with schema app_public;
>>>>>>> Stashed changes

CREATE TABLE version (version text);
INSERT INTO version values ('0.0.1');

\ir types.sql
\ir tables/main.sql
\ir functions/main.sql
\ir triggers/main.sql
