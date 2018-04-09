CREATE TABLE teams(
  id                      serial primary key,
  owner_id                int references owners on delete cascade not null,
  name                    title not null,
  service                 service not null default 'github'::service,
  service_id              citext not null,
  permissions             permission[]
);
COMMENT on column teams.owner_id is 'The GitHub Organization that this team belong to.';
COMMENT on column teams.name is 'The title of the Team.';
COMMENT on column teams.service_id is 'The GitHub unique service id.';
COMMENT on column teams.permissions is 'A list of permissions this team has permission to.';

CREATE UNIQUE INDEX teams_service_ids on teams (service, service_id);
