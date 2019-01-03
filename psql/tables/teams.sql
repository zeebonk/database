CREATE TABLE teams(
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid references owners on delete cascade not null,
  name                    title not null,
  UNIQUE (owner_uuid, name)
);
COMMENT on column teams.owner_uuid is 'The Owner that this team belong to.';
COMMENT on column teams.name is 'The title of the Team.';

CREATE INDEX teams_owner_uuid_fk on teams (owner_uuid);

CREATE TABLE team_permissions (
  team_uuid               uuid not null references teams on delete cascade,
  permission_slug         text not null references permissions on delete restrict,
  owner_uuid              uuid not null default uuid_nil() references owners on delete cascade,
  PRIMARY KEY (team_uuid, permission_slug)
);

CREATE FUNCTION tg_team_permissions__denormalize_owner_uuid() RETURNS TRIGGER AS $$
BEGIN
  NEW.owner_uuid = (SELECT owner_uuid FROM teams WHERE uuid = NEW.team_uuid);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql VOLATILE SET search_path FROM CURRENT;

CREATE TRIGGER _200_denormalize_owner_uuid
  BEFORE INSERT ON team_permissions
  FOR EACH ROW
  EXECUTE PROCEDURE tg_team_permissions__denormalize_owner_uuid();

CREATE TRIGGER _500_abort_on_team_owner_change
  BEFORE UPDATE ON teams
  FOR EACH ROW
  WHEN (OLD.owner_uuid IS DISTINCT FROM NEW.owner_uuid)
  EXECUTE PROCEDURE abort_with_errorcode('400', 'Teams are not allowed to move between owners.');

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
