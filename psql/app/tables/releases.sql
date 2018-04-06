create table releases(
  appid                   int references apps on delete cascade not null,
  releaseid               int not null,
  config                  json,
  message                 text not null,
  ownerid                 int references owners on delete set null,
  timestamp               timestamptz not null,
  state                   release_state not null
);

create unique index releases_pk on releases (appid, releaseid);
