create table tags(
  repoid                  int references repos on delete cascade not null,
  tag                     citext not null,
  message                 text,
  timestamp               timestamptz  -- last updated
);

create unique index tags_pk on releases (repoid, tag);
