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
  organization_uuid       uuid not null references organizations on delete cascade,
  PRIMARY KEY (team_uuid, permission_slug)
);

CREATE TABLE team_members(
  team_uuid                  uuid references teams on delete cascade not null,
  owner_uuid                 uuid references owners on delete cascade not null,
  primary key (team_uuid, owner_uuid)
);
COMMENT on table team_members is 'Collection of users that belong to a team.';
COMMENT on column team_members.owner_uuid is 'The member of the team.';

CREATE TABLE team_apps(
  team_uuid                  uuid references teams on delete cascade not null,
  app_uuid                   uuid references apps on delete cascade not null,
  primary key (team_uuid, app_uuid)
);
COMMENT on table team_members is 'Collection of apps that belong to a team.';
