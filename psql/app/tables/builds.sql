create table builds(
  buildid                 serial primary key,
  starttime               timestamptz not null,  -- time started
  endtime                 timestamptz not null,  -- time started
  repoid                  int references repos on delete cascade not null,
  commitid                text not null,
  state                   build_state not null
);