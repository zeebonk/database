create table apps(
  appid                   serial primary key,
  orgid                   int references orgs on delete cascade not null,
  repoid                  int references repos on delete cascade not null,
  name                    citext not null
);
comment on table apps is 'Owned by an org, an App is a group of Repos that make up an application.';

create table app_dns(
  domain                  citext primary key,
  appid                   int references apps on delete cascade not null,
  validated               boolean default false not null
);
comment on table app_dns is 'Apps may have many DNS endpoints that resolve to the application.';
comment on column app_dns.domain is 'A full DNS entry such as foobar.asyncyapp.com, example.com or *.everything.com';
comment on column app_dns.validated is 'If dns resolves properly from registry.';
