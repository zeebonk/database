-- CREATE TYPE plan_price_type as enum('per_user', 'per_node', 'metric');

CREATE TABLE plans(
  uuid                       uuid default uuid_generate_v4() primary key,
  service_uuid               uuid references services on delete cascade not null,
  title                      title not null,
  details                    jsonb
  -- price_type                 plan_price_type not null,
  -- price_per                  int CHECK (price_per >= 0) not null,
  -- price_rate                 numeric CHECK (price_rate >= 0) not null
);
COMMENT on table plans is 'Premium service plans.';
COMMENT on column plans.service_uuid is 'The service that owns this plan.';
COMMENT on column plans.title is 'A short name for the plan.';
COMMENT on column plans.details is 'Sales pitch content.';
-- COMMENT on column plans.price_type is 'The plans pricing variable, sum(type) is usage.';
-- COMMENT on column plans.price_per is 'Divide the usage by this this number, is the quanity.';
-- COMMENT on column plans.price_rate is 'The rate to multiple the quanity.';

CREATE INDEX plans_service_uuid_fk on plans (service_uuid);
