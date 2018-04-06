create schema app_public;
set search_path to app_public;

create extension "pgcrypto" with schema app_public;
create extension "uuid-ossp" with schema app_public;
create extension "citext" with schema app_public;

create table version (version text);
insert into version values ('0.0.1');

\ir types.sql
\ir tables/main.sql
\ir functions/main.sql
\ir triggers/main.sql
