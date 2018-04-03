create extension if not exists "uuid-ossp";
create extension if not exists "citext";

create table if not exists version (version text);

\ir types.sql
\ir tables/main.sql
\ir functions/main.sql
\ir triggers/main.sql
