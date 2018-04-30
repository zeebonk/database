CREATE TABLE subscriptions(
  uuid                       uuid default uuid_generate_v4() primary key,
  organization_uuid          uuid references organizations on delete cascade not null,
  plan_uuid                  uuid references plans on delete restrict not null,
  app_uuid                   uuid references repos on delete cascade
);
COMMENT on table subscriptions is 'An organization subscriptions to servies.';
COMMENT on column subscriptions.organization_uuid is 'The owner of the subscription, for billing purposes.';
COMMENT on column subscriptions.plan_uuid is 'Link to the plan subscribing too.';
COMMENT on column subscriptions.app_uuid is 'If plan is per-app, the app this plan links too.';

CREATE INDEX subscriptions_organization_uuid_fk on subscriptions (organization_uuid);
CREATE INDEX subscriptions_plan_uuid_fk on subscriptions (plan_uuid);
CREATE INDEX subscriptions_app_uuid_fk on subscriptions (app_uuid);
