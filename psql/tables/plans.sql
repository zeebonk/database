CREATE TYPE plan_price_type as enum('per_user', 'per_node', 'metric');

CREATE TABLE plans(
  id                         serial primary key,
  service_id                 int references services on delete cascade not null,
  title                      title not null,
  details                    json,
  price_type                 plan_price_type not null,
  price_per                  int CHECK (price_per >= 0) not null,
  price_rate                 numeric CHECK (price_rate >= 0) not null
);
COMMENT on table plans is 'Premium service plans.';
COMMENT on column plans.service_id is 'The service that owns this plan.';
COMMENT on column plans.title is 'A short name for the plan.';
COMMENT on column plans.details is 'Sales pitch content.';
COMMENT on column plans.price_type is 'The plans pricing variable, sum(type) is usage.';
COMMENT on column plans.price_per is 'Divide the usage by this this number, is the quanity.';
COMMENT on column plans.price_rate is 'The rate to multiple the quanity.';
