-- Org can have N apps
create table apps(
  appid                   serial primary key,
  orgid                   int references orgs on delete cascade not null,
  name                    citext not null
);

create table app_dns(
  appid                   int references apps on delete cascade not null,
  domain                  citext unique not null,
  validated               boolean default false not null
);

-- Comments --
comment on table apps is 'Owned by an org, an App is a group of Repos that make up an application.';
comment on table app_dns is 'Apps may have many DNS endpoints that resolve to the application.';
comment on column app_dns.domain is 'A full dns entry such as foobar.asyncyapp.com, example.com or *.everything.com';
comment on column app_dns.validated is 'If dns resolves properly from registry.';
