CREATE TABLE repos(
  repoid                     serial primary key,
  ownerid                    int references owners on delete cascade not null,  -- slug:owner
  service_id                 text not null,
  name                       citext not null,  -- slug:name
  alias                      citext,
  pull_url                   citext,
  github_using_installation  boolean not null default false
);

CREATE UNIQUE INDEX repos_slug on repos (ownerid, name);

CREATE UNIQUE INDEX repos_service_ids on repos (ownerid, service_id);

CREATE UNIQUE INDEX repos_alias on repos (alias);
