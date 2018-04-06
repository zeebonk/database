create table orgs(
  orgid                   serial primary key,
  name                    citext not null
);
comment on table orgs is 'Top-level Organizations in Asyncy. An organization is a collection of many apps.';
