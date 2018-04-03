
create table members(
  teamid                  int references teams on delete cascade not null,
  ownerid                 int references owners on delete cascade not null
);

create unique index members_pk on members (teamid, ownerid);
