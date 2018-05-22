CREATE TABLE teams(
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid references owners on delete cascade not null,
  name                    title not null,
  service                 git_service not null default 'github'::git_service,
  service_id              citext CHECK (LENGTH(service_id) < 45) not null
);
COMMENT on column teams.owner_uuid is 'The GitHub Organization that this team belong to.';
COMMENT on column teams.name is 'The title of the Team.';
COMMENT on column teams.service_id is 'The GitHub unique service id.';

CREATE UNIQUE INDEX teams_service_ids on teams (service, service_id);

CREATE INDEX teams_owner_uuid_fk on teams (owner_uuid);

CREATE TABLE team_permissions (
  team_uuid               uuid not null references teams on delete cascade,
  permission_uuid         uuid not null references permissions on delete restrict,
  PRIMARY KEY (team_uuid, permission_uuid)
);
