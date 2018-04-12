CREATE TYPE release_state as enum('previous', 'active', 'next', 'rollback', 'queued');

CREATE TABLE releases(
  id                      int not null,  -- TODO next by app_id
  app_id                  int references apps on delete cascade not null,
  config                  json,
  message                 text not null,
  owner_id                int references owners on delete set null,
  timestamp               timestamptz not null,
  state                   release_state not null default 'queued'::release_state,
  payload                 json,
  primary key (id, app_id)
) without oids;
COMMENT on table releases is 'Identifying the active version of the application.';
COMMENT on column releases.app_id is 'The application this release belongs to.';
COMMENT on column releases.config is 'Configuration of the release.';
COMMENT on column releases.message is 'User defined release message.';
COMMENT on column releases.owner_id is 'The person who submitted the release.';
COMMENT on column releases.timestamp is 'Time when release was first created.';
COMMENT on column releases.state is 'Identifying which release is active or rolling in/out.';
COMMENT on column releases.payload is 'An object containing the full payload of Storyscripts, e.g., {"foobar": {"1": ...}}';

CREATE FUNCTION releases_next_id() returns trigger as $$
  begin
    new.id := coalesce((select max(id) from releases where app_id=new.app_id), 0) + 1;
    return new;
  end;
$$ language plpgsql;

CREATE TRIGGER releases_next_id_insert before insert on releases
  for each row execute procedure releases_next_id();
