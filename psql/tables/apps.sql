CREATE TABLE apps(
  uuid                    uuid default uuid_generate_v4() primary key,
  organization_uuid       uuid references organizations on delete cascade not null,
  repo_uuid               uuid references repos on delete cascade,
  name                    title not null,
  timestamp               timestamptz not null,
  maintenance             boolean default false not null
);
COMMENT on table apps is 'Owned by an org, an App is a group of Repos that make up an application.';
COMMENT on column apps.timestamp is 'Date the application was created.';

CREATE INDEX apps_organization_uuid_fk on apps (organization_uuid);
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
