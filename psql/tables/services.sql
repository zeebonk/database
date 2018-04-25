CREATE TABLE services(
  uuid                       uuid default uuid_generate_v4() primary key,
  repo_uuid                  uuid references repos on delete cascade not null,
  alias                      alias unique,
  pull_url                   url,
  topics                     citext[],  -- TODO why cannot use title?
  state                      service_state
);
COMMENT on column services.alias is 'The namespace reservation for the container';
COMMENT on column services.pull_url is 'Address where the container can be pulled from.';
COMMENT on column services.topics is 'GitHub repository topics for searching services.';

CREATE INDEX services_repo_uuid_fk on services (repo_uuid);
