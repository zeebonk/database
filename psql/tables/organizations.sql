CREATE TABLE organizations(
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid not null default current_owner_uuid(),
  name                    title not null,
  username                alias not null
);
COMMENT on table organizations is 'An organization is a collection of many teams, apps and repositories.';
COMMENT on column organizations.owner_uuid is 'The owner of the Organization.';
COMMENT on column organizations.name is 'The organization name for visual purposes.';
COMMENT on column organizations.username is 'The organization username for navigation and internal purposes.';


CREATE INDEX ON organizations (owner_uuid);

CREATE TABLE organization_billing(
  organization_uuid       uuid primary key references organizations on delete cascade,
  region                  billing_region,
  customer                varchar(45) CHECK (customer ~ '^cust_\w+$'),
  subscription            varchar(45) CHECK (customer ~ '^sub_\w+$'),
  email                   email not null,
  address                 varchar(512),
  vat                     varchar(45)
);


-- TODO org_admins

-- TODO (Should this be per org or app or both?)
-- CREATE TABLE org_subscriptions(
--   subscriptionid          serial primary key,
--   orgid                   int references organizations not null,
--   serviceid               int references hub_public.service_plans not null,
--   appid                   int references apps,
--   quantity                int CHECK (quantity > 0),
--   config                  jsonb
-- );
