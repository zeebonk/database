CREATE TABLE orgs(
  id                      serial primary key,
  name                    title not null
) without oids;
COMMENT on table orgs is 'An organization is a collection of many teams, apps and repositories.';

CREATE TYPE billing_region as enum('us', 'eu');

CREATE TABLE org_billing(
  org_id                  int primary key references orgs on delete cascade,
  region                  billing_region,
  customer                text CHECK (customer ~ '^cust_\w+$'),
  subscription            text CHECK (customer ~ '^sub_\w+$'),
  email                   email,
  address                 text,
  vat                     text
) without oids;

-- TODO org_admins

-- TODO (Should this be per org or app or both?)
-- CREATE TABLE org_subscriptions(
--   subscriptionid          serial primary key,
--   orgid                   int references orgs not null,
--   serviceid               int references hub_public.service_plans not null,
--   appid                   int references apps,
--   quantity                int CHECK (quantity > 0),
--   config                  json
-- );
