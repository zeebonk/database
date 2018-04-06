create table owners(
  ownerid                 serial primary key,
  service                 service not null,
  service_id              citext not null,  -- the GitHub Service ID
  username                citext not null,
  email                   citext,
  name                    citext,
  oauth_token             text,  -- encripted
  github_installation_id  int  -- github integration id
);

create unique index owner_service_username on owners (service, username);

create unique index owner_service_ids on owners (service, service_id);
