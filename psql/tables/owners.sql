CREATE TABLE owners(
  uuid                    uuid default uuid_generate_v4() primary key,
  service                 service not null default 'github'::service,
  service_id              citext not null,
  is_user                 boolean not null default true,
  username                username not null,
  email                   email,
  name                    title not null,
  oauth_token             varchar(45),
  github_installation_id  int,
  permissions             uuid[]
) without oids;
COMMENT on column owners.service is 'GitHub or another provider';
COMMENT on column owners.service_id is 'The providers unique id';
COMMENT on column owners.username is 'The handler name to the provider service';
COMMENT on column owners.name is 'A pretty organization name, UI visual only.';
COMMENT on column owners.oauth_token is 'Stored as an encripted string';
COMMENT on column owners.github_installation_id is 'The installation id to the GitHub App';

CREATE UNIQUE INDEX owner_service_username on owners (service, username);
COMMENT on index owner_service_username is 'Can only have one service:username pair.';

CREATE UNIQUE INDEX owner_service_ids on owners (service, service_id);
COMMENT on index owner_service_ids is 'Can only have one service:service_id pair.';

CREATE TRIGGER _100_insert_assert_permissions_exist before insert on owners
  for each row
  when (array_length(new.permissions, 1) > 0)
  execute procedure assert_permissions_exist();

CREATE TRIGGER _100_update_assert_permissions_exist before update on owners
  for each row
  when (new.permissions is distinct from old.permissions and array_length(new.permissions, 1) > 0)
  execute procedure assert_permissions_exist();
