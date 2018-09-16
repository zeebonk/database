ALTER TABLE plans ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_all ON plans FOR SELECT USING (true);
GRANT SELECT ON plans TO asyncy_visitor;

-- Do not grant INSERT, UPDATE, DELETE - these permissions are managed by the system, not users.

----

ALTER TABLE plan_subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_billing ON plan_subscriptions FOR SELECT USING (organization_uuid = ANY(current_owner_organization_uuids(ARRAY['BILLING'])));
GRANT SELECT ON plan_subscriptions TO asyncy_visitor;

-- Do not grant INSERT, UPDATE, DELETE - these permissions are managed by the system, not users.
