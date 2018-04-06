create table repos(
  repoid                     serial primary key,
  ownerid                    int references owners on delete cascade not null,
  service                    service not null default 'github'::service,
  service_id                 citext unique not null,
  name                       citext,
  github_using_installation  boolean not null default false
);
comment on column repos.ownerid is 'The GitHub Organization that owns this repository.';
comment on column repos.service is 'The repositorys service provider.';
comment on column repos.service_id is 'The unique GitHub id of the repository.';
comment on column repos.name is 'The repository slug name.';
comment on column repos.github_using_installation is 'True: if the repository is using the GitHub App Integration';

create unique index repos_slug on repos (ownerid, name);
comment on index repos_slug is 'A repository name is unique per GitHub Organization.';

create unique index repos_service_ids on repos (service, service_id);
comment on index repos_service_ids is 'A repository service id is unique per Service.';
