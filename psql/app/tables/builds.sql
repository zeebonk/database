create table builds(
  buildid                 int not null,
  repoid                  int references repos on delete cascade not null,
  timestamp               timestamptz not null,
  sha                     text not null,
  state                   build_state not null,
  primary key (buildid, repoid)
);
comment on table builds is 'Building results from an Application.';
comment on column builds.timestamp is 'Date the build started.';
comment on column builds.sha is 'The commit id of the build being tested.';
comment on column builds.state is 'The state of the build.';

-- TODO builds.buildid should be next_var per appid
