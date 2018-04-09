create schema if not exists hub_public;
set search_path to hub_public;

create extension if not exists "uuid-ossp" with schema hub_public;
create extension if not exists "citext" with schema hub_public;

create table version (version text);
insert into version values ('0.0.1');

\ir types.sql
\ir tables/main.sql
