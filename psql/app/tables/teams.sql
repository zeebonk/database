create table teams(
  teamid                  serial primary key,
  ownerid                 int references owners on delete cascade not null,
  name                    text not null,
  service                 service not null default 'github'::service,
  service_id              citext not null,
  permissions             permission[]
);
comment on column teams.ownerid is 'The GitHub Organization that this team belong to.';
comment on column teams.name is 'The title of the Team.';
comment on column teams.service_id is 'The GitHub unique service id.';
comment on column teams.permissions is 'A list of permissions this team has permission to.';

create unique index teams_service_ids on teams (service, service_id);
