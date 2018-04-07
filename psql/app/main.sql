create schema if not exists app_public;
set search_path to app_public;

\c app
create extension if not exists "pgcrypto" with schema app_public;
create extension if not exists "uuid-ossp" with schema app_public;
create extension if not exists "citext" with schema app_public;

create table version (version text);
insert into version values ('0.0.1');

\ir types.sql
\ir tables/main.sql
\ir functions/main.sql
\ir triggers/main.sql
