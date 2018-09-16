ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_member ON organizations FOR SELECT USING (uuid = ANY (current_owner_organization_uuids()));
GRANT SELECT ON organizations TO asyncy_visitor;

----

ALTER TABLE organization_billing ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_member ON organization_billing FOR SELECT USING (organization_uuid = ANY (current_owner_organization_uuids(ARRAY['BILLING'])));
GRANT SELECT ON organization_billing TO asyncy_visitor;
