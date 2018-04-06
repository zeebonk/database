create table members(
  teamid                  int references teams on delete cascade not null,
  ownerid                 int references owners on delete cascade not null,
  primary key (teamid, ownerid)
);
comment on table members is 'Collection of users that belong to a team.';
