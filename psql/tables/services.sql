CREATE TYPE service_state as enum('stable', 'development', 'archived');
CREATE TABLE services(
  uuid                       uuid default uuid_generate_v4() primary key,
  repo_uuid                  uuid references repos on delete cascade not null,
  alias                      alias unique,
  pull_url                   citext,
  topics                     text[],
  state                      service_state
) without oids;
COMMENT on column services.alias is 'The namespace reservation for the container';
COMMENT on column services.pull_url is 'Address where the container can be pulled from.';
COMMENT on column services.topics is 'GitHub repository topics for searching services.';
