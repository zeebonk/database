CREATE TABLE teams(
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid references owners on delete cascade not null,
  name                    title not null,
  service                 service not null default 'github'::service,
  service_id              citext CHECK (LENGTH(service_id) < 45) not null,
  permissions             uuid[]
);
COMMENT on column teams.owner_uuid is 'The GitHub Organization that this team belong to.';
COMMENT on column teams.name is 'The title of the Team.';
COMMENT on column teams.service_id is 'The GitHub unique service id.';
COMMENT on column teams.permissions is 'A list of permissions this team has permission to.';

CREATE UNIQUE INDEX teams_service_ids on teams (service, service_id);

CREATE INDEX teams_owner_uuid_fk on teams (owner_uuid);

CREATE TRIGGER _100_insert_assert_permissions_exist before insert on teams
  for each row
  when (array_length(new.permissions, 1) > 0)
  execute procedure assert_permissions_exist();

CREATE TRIGGER _100_update_assert_permissions_exist before update on teams
  for each row
  when (new.permissions is distinct from old.permissions and array_length(new.permissions, 1) > 0)
  execute procedure assert_permissions_exist();
