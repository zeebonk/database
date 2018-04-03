create table repos(
  repoid                     serial primary key,
  ownerid                    int references owners on delete cascade not null,  -- slug:owner
  service_id                 text not null,
  name                       citext,  -- slug:name
  github_using_installation  boolean not null default false
);

create unique index repos_slug on repos (ownerid, name);

create unique index repos_service_ids on repos (ownerid, service_id);


-- App can have N Repos
create table app_repos(
  appid                   int references apps on delete cascade not null,
  repoid                  int references repos on delete cascade not null
);

create unique index app_repo_pk on app_repos (appid, repoid);
