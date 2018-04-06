create schema hub_public;
set search_path to hub_public;

create extension "uuid-ossp" with schema hub_public;
create extension "citext" with schema hub_public;

create table version (version text);

\ir types.sql
\ir tables/main.sql
