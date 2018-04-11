CREATE TABLE members(
  team_id                  int references teams on delete cascade not null,
  owner_id                 int references owners on delete cascade not null,
  primary key (team_id, owner_id)
) without oids;
COMMENT on table members is 'Collection of users that belong to a team.';
