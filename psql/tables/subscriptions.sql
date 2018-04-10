CREATE TABLE subscriptions(
  id                         serial primary key,
  org_id                     int references orgs on delete cascade not null,
  plan                       int references plans not null,
  app_id                     int references repos on delete cascade
);
COMMENT on table subscriptions is 'An organization subscriptions to servies.';
COMMENT on column subscriptions.org_id is 'The owner of the subscription, for billing purposes.';
COMMENT on column subscriptions.plan is 'Link to the plan subscribing too.';
COMMENT on column subscriptions.app_id is 'If plan is per-app, the app this plan links too.';
