CREATE TABLE subscriptions(
  uuid                       uuid default uuid_generate_v4() primary key,
  organization_uuid          uuid references organizations on delete cascade not null,
  plan_uuid                  uuid references plans not null,
  app_uuid                   uuid references repos on delete cascade
) without oids;
COMMENT on table subscriptions is 'An organization subscriptions to servies.';
COMMENT on column subscriptions.organization_uuid is 'The owner of the subscription, for billing purposes.';
COMMENT on column subscriptions.plan_uuid is 'Link to the plan subscribing too.';
COMMENT on column subscriptions.app_uuid is 'If plan is per-app, the app this plan links too.';
