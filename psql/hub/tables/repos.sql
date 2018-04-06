create table repos(
  repoid                     serial primary key,
  ownerid                    int references owners on delete cascade not null,  -- slug:owner
  service_id                 text not null,
  name                       citext not null,  -- slug:name
  alias                      citext,
  pull_url                   citext,
  github_using_installation  boolean not null default false
);

create unique index repos_slug on repos (ownerid, name);

create unique index repos_service_ids on repos (ownerid, service_id);

create unique index repos_alias on repos (alias);
