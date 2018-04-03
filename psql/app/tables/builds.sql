create table builds(
  buildid                 serial primary key,
  timestamp               timestamptz not null,  -- time started
  repoid                  int references repos on delete cascade not null,
  commitid                text not null,
  state                   build_state not null
);
