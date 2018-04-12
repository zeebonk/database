CREATE TABLE apps(
  id                      serial primary key,
  org_id                  int references orgs on delete cascade not null,
  repo_id                 int references repos on delete cascade not null,
  name                    title not null
) without oids;
COMMENT on table apps is 'Owned by an org, an App is a group of Repos that make up an application.';

CREATE TABLE app_dns(
  hostname                hostname primary key,
  app_id                  int references apps on delete cascade not null,
  validated               boolean default false not null
) without oids;
COMMENT on table app_dns is 'Apps may have many DNS endpoints that resolve to the application.';
COMMENT on column app_dns.hostname is 'A full hostname entry such as foobar.asyncyapp.com, example.com or *.everything.com';
COMMENT on column app_dns.validated is 'If dns resolves properly from registry.';