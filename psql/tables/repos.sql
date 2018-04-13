CREATE TABLE repos(
  uuid                       uuid default uuid_generate_v4() primary key,
  owner_uuid                 uuid references owners on delete cascade not null,
  service                    service not null default 'github'::service,
  service_id                 citext unique CHECK (LENGTH(service_id) < 45) not null,
  name                       username,
  github_using_installation  boolean not null default false,
  webhook_id                 citext CHECK (LENGTH(webhook_id) < 30)
) without oids;
COMMENT on column repos.owner_uuid is 'The GitHub Organization that owns this repository.';
COMMENT on column repos.service is 'The repositorys service provider.';
COMMENT on column repos.service_id is 'The unique GitHub id of the repository.';
COMMENT on column repos.name is 'The repository slug name.';
COMMENT on column repos.github_using_installation is 'True: if the repository is using the GitHub App Integration';
COMMENT on column repos.webhook_id is 'External service webhook id, if setup.';

CREATE UNIQUE INDEX repos_slug on repos (owner_uuid, name);
COMMENT on index repos_slug is 'A repository name is unique per GitHub Organization.';

CREATE UNIQUE INDEX repos_service_ids on repos (service, service_id);
COMMENT on index repos_service_ids is 'A repository service id is unique per Service.';
