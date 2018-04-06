create schema hub_public;
set search_path to hub_public;

create extension "uuid-ossp" with schema hub_public;
create extension "citext" with schema hub_public;

create table version (version text);
insert into version values ('0.0.1');

\ir types.sql
\ir tables/main.sql
