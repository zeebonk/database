create table builds(
  buildid                 serial primary key,
  starttime               timestamptz,  -- time started
  endtime                 timestamptz,  -- time ended
  repoid                  int references repos on delete cascade not null,
  commitid                text not null,
  state                   build_state not null
);
