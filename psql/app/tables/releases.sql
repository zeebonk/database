create table releases(
  releaseid               int not null,
  appid                   int references apps on delete cascade not null,
  config                  json,
  message                 text not null,
  ownerid                 int references owners on delete set null,
  timestamp               timestamptz not null,
  state                   release_state not null default 'queued'::release_state,
  payload                 json,
  primary key (releaseid, appid)
);
comment on table releases is 'Identifying the active version of the application.';
comment on column releases.appid is 'The application this release belongs to.';
comment on column releases.config is 'Configuration of the release.';
comment on column releases.message is 'User defined release message.';
comment on column releases.ownerid is 'The person who submitted the release.';
comment on column releases.timestamp is 'Time when release was first created.';
comment on column releases.state is 'Identifying which release is active or rolling in/out.';
comment on column releases.payload is 'An object containing the full payload of Storyscripts, e.g., {"foobar": {"1": ...}}';

-- TODO releases.releaseid should be next_var per appid
