CREATE TABLE teams(
  uuid                    uuid default uuid_generate_v4() primary key,
  organization_uuid       uuid references organizations on delete cascade not null,
  name                    title not null,
  UNIQUE (organization_uuid, name)
);
COMMENT on column teams.organization_uuid is 'The Organization that this team belong to.';
COMMENT on column teams.name is 'The title of the Team.';

CREATE INDEX teams_owner_uuid_fk on teams (organization_uuid);

CREATE TABLE team_permissions (
  team_uuid               uuid not null references teams on delete cascade,
  permission_slug         text not null references permissions on delete restrict,
  PRIMARY KEY (team_uuid, permission_slug)
);
