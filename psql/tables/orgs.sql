CREATE TABLE organizations(
  uuid                    uuid default uuid_generate_v4() primary key,
  name                    title not null
);
COMMENT on table organizations is 'An organization is a collection of many teams, apps and repositories.';

CREATE TABLE organization_billing(
  organization_uuid       uuid primary key references organizations on delete cascade,
  region                  billing_region,
  customer                varchar(45) CHECK (customer ~ '^cust_\w+$'),
  subscription            varchar(45) CHECK (customer ~ '^sub_\w+$'),
  email                   email,
  address                 varchar(45),
  vat                     varchar(45)
);

CREATE INDEX organization_billing_organization_uuid_fk on organization_billing (organization_uuid);


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
