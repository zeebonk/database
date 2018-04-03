create table owners(
  ownerid                 serial primary key,
  service                 service not null,
  service_id              text not null,  -- the GitHub Service ID
  createstamp             timestamptz,
  username                citext,
  email                   text,
  name                    text,
  oauth_token             text,  -- encripted
  github_installation_id  int,  -- github integration id
  permissions             permission[]
);

create unique index owner_service_username on owners (service, username);

create unique index owner_service_ids on owners (service, service_id);
