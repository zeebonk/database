CREATE TABLE owners(
  uuid                    uuid default uuid_generate_v4() primary key,
  is_user                 boolean not null default true,
  username                username not null,
  createstamp             timestamptz not null default now(),
  name                    citext
);
COMMENT on column owners.username is 'Unique namespace for nagivation and discovery.';
COMMENT on column owners.name is 'A pretty organization name, UI visual only.';

CREATE UNIQUE INDEX owner_username on owners (username);

CREATE TABLE owner_services (
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid not null references owners on delete cascade,
  service                 git_service not null default 'github'::git_service,
  service_id              citext not null,
  username                username not null,
  createstamp             timestamptz not null default now(),
  github_installation_id  int default null
);
COMMENT on column owner_services.username is 'The handler name to the provider service';
COMMENT on column owner_services.service is 'GitHub or another provider';
COMMENT on column owner_services.service_id is 'The providers unique id';
COMMENT on column owner_services.github_installation_id is 'The installation id to the GitHub App';

CREATE UNIQUE INDEX owner_service_username on owner_services (service, username);
CREATE UNIQUE INDEX owner_service_ids on owner_services (service, service_id);
COMMENT on index owner_service_username is 'Can only have one service:username pair.';
COMMENT on index owner_service_ids is 'Can only have one service:service_id pair.';

CREATE TABLE owner_emails (
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid not null references owners on delete cascade,
  email                   email not null,
  is_verified             boolean not null default false
);

CREATE UNIQUE INDEX ON owner_emails(owner_uuid, email); -- This index serves two purposes

CREATE TABLE app_private.owner_service_secrets (
  owner_service_uuid      uuid primary key references owner_services on delete cascade,
  oauth_token             varchar(45)
);
COMMENT on column app_private.owner_service_secrets.oauth_token is 'Stored as an encrypted string';

CREATE TABLE app_private.owner_billing(
  owner_uuid              uuid primary key references owners on delete cascade,
  region                  billing_region not null default 'US'::billing_region,
  customer                varchar(45) CHECK (customer ~ '^cust_\w+$') not null,
  subscription            varchar(45) CHECK (customer ~ '^sub_\w+$'),
  email                   email,
  address                 varchar(512),
  vat                     varchar(45)
);
COMMENT on column app_private.owner_billing.customer is 'Stripe customer ID.';
COMMENT on column app_private.owner_billing.subscription is 'Stripe subscriptions ID.';
COMMENT on column app_private.owner_billing.email is 'Where to send receipts to.';


CREATE TABLE app_private.owner_subscriptions(
  uuid                       uuid default uuid_generate_v4() primary key,
  owner_uuid                 uuid references owners on delete cascade not null,
  plan_uuid                  uuid references service_plans on delete restrict not null
);
COMMENT on table plan_subscriptions is 'An owner subscriptions to servies.';
COMMENT on column plan_subscriptions.owner_uuid is 'The owner of the subscription, for billing purposes.';
COMMENT on column plan_subscriptions.plan_uuid is 'Link to the plan subscribing too.';

CREATE INDEX owner_subscriptions_owner_uuid_fk on app_private.owner_subscriptions (owner_uuid);
CREATE INDEX owner_subscriptions_plan_uuid_fk on app_private.owner_subscriptions (plan_uuid);
