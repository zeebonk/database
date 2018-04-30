CREATE TABLE builds(
  repo_uuid               uuid references repos on delete cascade not null,
  id                      int CHECK (id > 0) not null default 0,
  timestamp               timestamptz not null,
  sha                     sha not null,
  state                   build_state not null,
  primary key (repo_uuid, id)
);
COMMENT on table builds is 'Building results from an Application.';
COMMENT on column builds.timestamp is 'Date the build started.';
COMMENT on column builds.sha is 'The commit id of the build being tested.';
COMMENT on column builds.state is 'The state of the build.';

CREATE TABLE app_private.build_numbers (
  repo_uuid               uuid references repos on delete cascade primary key,
  build_number            int not null default 1
);

CREATE FUNCTION builds_next_id() returns trigger as $$
  declare
    v_next_value int;
  begin
    -- TODO: this statement should be committed immediately in a separate
    -- transaction so that it behaves more like PostgreSQL sequences to avoid
    -- race conditions.
    -- Relevant: http://blog.dalibo.com/2016/08/19/Autonoumous_transactions_support_in_PostgreSQL.html
    insert into app_private.build_numbers (repo_uuid) values (NEW.repo_uuid) on conflict (repo_uuid) do update set build_number = build_number + 1 returning build_number into v_next_value;
    new.id := v_next_value;
    return new;
  end;
$$ language plpgsql security definer;

CREATE TRIGGER _100_builds_next_id_insert before insert on builds
  for each row execute procedure builds_next_id();
