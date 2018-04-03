-- Org can have N apps
create table apps(
  appid                   serial primary key,
  orgid                   int references orgs on delete cascade not null,
  domain                  citext not null,  -- for {}.asyncyapp.com
  name                    text not null
);

create unique index apps_domain on apps (domain);

-- App can have N dns
create table apps_dns(
  appid                   int references apps on delete cascade not null,
  domain                  citext not null,  -- foobar.com
  validated               boolean default false not null
);

create unique index apps_dns_domain on apps_dns (domain);
