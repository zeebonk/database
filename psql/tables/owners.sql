CREATE TABLE owners(
  uuid                    uuid default uuid_generate_v4() primary key,
  service                 service not null default 'github'::service,
  service_id              citext not null,
  is_user                 boolean not null default true,
  username                username not null,
  name                    title not null,
  github_installation_id  int
);
COMMENT on column owners.service is 'GitHub or another provider';
COMMENT on column owners.service_id is 'The providers unique id';
COMMENT on column owners.username is 'The handler name to the provider service';
COMMENT on column owners.name is 'A pretty organization name, UI visual only.';
COMMENT on column owners.github_installation_id is 'The installation id to the GitHub App';

CREATE UNIQUE INDEX owner_service_username on owners (service, username);
COMMENT on index owner_service_username is 'Can only have one service:username pair.';

CREATE UNIQUE INDEX owner_service_ids on owners (service, service_id);
COMMENT on index owner_service_ids is 'Can only have one service:service_id pair.';


CREATE TABLE owner_permissions (
  owner_uuid              uuid not null references owners on delete cascade,
  permission_uuid         uuid not null references permissions on delete restrict,
  PRIMARY KEY (owner_uuid, permission_uuid)
);

CREATE TABLE owner_emails (
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid not null references owners on delete cascade,
  email                   email not null,
  is_verified             boolean not null default false
);

CREATE UNIQUE INDEX ON owner_emails(owner_uuid, email); -- This index serves two purposes

CREATE TABLE owner_secrets (
  owner_uuid              uuid primary key references owners on delete cascade,
  oauth_token             varchar(45),
  email_verification_code varchar(30)
);
COMMENT on column owner_secrets.oauth_token is 'Stored as an encrypted string';
