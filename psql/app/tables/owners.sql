create table owners(
  ownerid                 serial primary key,
  service                 service not null default 'github'::service,
  service_id              citext not null,
  username                citext not null,
  email                   citext,
  name                    citext not null,
  oauth_token             text,
  github_installation_id  int,
  permissions             permission[]
);
comment on column owners.service is 'GitHub or another provider';
comment on column owners.service_id is 'The providers unique id';
comment on column owners.username is 'The handler name to the provider service';
comment on column owners.name is 'A pretty organization name, UI visual only.';
comment on column owners.oauth_token is 'Stored as an encripted string';
comment on column owners.github_installation_id is 'The installation id to the GitHub App';

create unique index owner_service_username on owners (service, username);
comment on index owner_service_username is 'Can only have one service:username pair.';

create unique index owner_service_ids on owners (service, service_id);
comment on index owner_service_ids is 'Can only have one service:service_id pair.';
