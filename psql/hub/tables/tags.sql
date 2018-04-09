CREATE TABLE tags(
  repoid                  int references repos on delete cascade not null,
  tag                     citext not null,
  message                 text,
  timestamp               timestamptz  -- last updated
);

CREATE UNIQUE INDEX tags_pk on releases (repoid, tag);
