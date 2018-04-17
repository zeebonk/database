CREATE TABLE members(
  team_uuid                  uuid references teams on delete cascade not null,
  owner_uuid                 uuid references owners on delete cascade not null,
  primary key (team_uuid, owner_uuid)
);
COMMENT on table members is 'Collection of users that belong to a team.';
