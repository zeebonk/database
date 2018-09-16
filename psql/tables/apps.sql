CREATE TABLE apps(
  uuid                    uuid default uuid_generate_v4() primary key,
  organization_uuid       uuid references organizations on delete cascade,
  owner_uuid              uuid references owners on delete cascade,
  repo_uuid               uuid references repos on delete cascade,
  name                    title not null,
  timestamp               timestamptz not null default now(),
  maintenance             boolean default false not null,
  deleted                 boolean default false not null,
  CONSTRAINT must_have_exactly_one_owner CHECK (
    (organization_uuid IS NULL) <> (owner_uuid IS NULL)
  ),
  UNIQUE (organization_uuid, name),
  UNIQUE (owner_uuid, name)
);
COMMENT on table apps is 'Owned by an org, an App is a group of Repos that make up an application.';
COMMENT on column apps.timestamp is 'Date the application was created.';
COMMENT on column apps.organization_uuid is 'The Organization that owns this application.';
COMMENT on column apps.owner_uuid is 'The Owner that owns this application.';
COMMENT on column apps.repo_uuid is 'The Repository linked to this application.';

CREATE INDEX apps_organization_uuid_fk on apps (organization_uuid);
CREATE INDEX apps_owners_uuid_fk on apps (owner_uuid);
CREATE INDEX apps_repo_uuid_fk on apps (repo_uuid);

CREATE TABLE app_dns(
  hostname                hostname primary key,
  app_uuid                uuid references apps on delete cascade not null,
  is_validated            boolean default false not null
);
COMMENT on table app_dns is 'Apps may have many DNS endpoints that resolve to the application.';
COMMENT on column app_dns.hostname is 'A full hostname entry such as foobar.asyncyapp.com, example.com or *.everything.com';
COMMENT on column app_dns.is_validated is 'If dns resolves properly from registry.';

CREATE INDEX app_dns_app_uuid_fk on app_dns (app_uuid);

CREATE FUNCTION apps_create_dns() returns trigger as $$
  DECLARE dns hostname default null;
  BEGIN

    BEGIN
      INSERT INTO app_dns (hostname, app_uuid, is_validated)
        VALUES (convert_to_hostname(new.name), new.uuid, true)
        ON CONFLICT (hostname) DO NOTHING
        RETURNING hostname into dns;

      IF dns IS NOT NULL THEN
        RETURN new;
      END IF;
    EXCEPTION WHEN check_violation THEN
      -- Do nothing
    END;

    LOOP
      INSERT INTO app_dns (hostname, app_uuid, is_validated)
        VALUES (generate_awesome_word()::hostname, new.uuid, true)
        ON CONFLICT (hostname) DO NOTHING
        RETURNING hostname into dns;

      IF dns IS NOT NULL THEN
        RETURN new;
      END IF;
    END LOOP;

  END;
$$ language plpgsql security definer SET search_path FROM CURRENT;

CREATE TRIGGER _101_apps_create_dns after insert on apps
  for each row execute procedure apps_create_dns();
