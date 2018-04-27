CREATE TABLE releases(
  app_uuid                uuid references apps on delete cascade not null,
  id                      int CHECK (id > 0) not null,
  config                  jsonb,
  message                 text CHECK (LENGTH(message) < 1000) not null,
  owner_uuid              uuid references owners on delete set null,
  timestamp               timestamptz not null,
  state                   release_state not null default 'queued'::release_state,
  payload                 jsonb not null,
  primary key (app_uuid, id)
);
COMMENT on table releases is 'Identifying the active version of the application.';
COMMENT on column releases.app_uuid is 'The application this release belongs to.';
COMMENT on column releases.config is 'Configuration of the release.';
COMMENT on column releases.message is 'User defined release message.';
COMMENT on column releases.owner_uuid is 'The person who submitted the release.';
COMMENT on column releases.timestamp is 'Time when release was first created.';
COMMENT on column releases.state is 'Identifying which release is active or rolling in/out.';
COMMENT on column releases.payload is 'An object containing the full payload of Storyscripts, e.g., {"foobar": {"1": ...}}';

CREATE FUNCTION releases_next_id() returns trigger as $$
  begin
    new.id := coalesce((select max(id) from releases where app_uuid=new.app_uuid), 0) + 1;
    return new;
  end;
$$ language plpgsql;

CREATE TRIGGER releases_next_id_insert before insert on releases
  for each row execute procedure releases_next_id();
