create table releases(
  appid                   int references apps on delete cascade not null,
  releaseid               int not null,
  config                  json,
  message                 text,
  ownerid                 int references owners on delete set null,
  timestamp               timestamptz,
  state                   release_state not null
);

create unique index releases_pk on releases (appid, releaseid);
