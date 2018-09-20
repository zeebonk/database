ALTER TABLE apps ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_own ON apps FOR SELECT USING (owner_uuid = current_owner_uuid());
CREATE POLICY select_organization ON apps FOR SELECT USING (organization_uuid = ANY (current_owner_organization_uuids()));
GRANT SELECT ON apps TO asyncy_visitor;

CREATE POLICY insert_own ON apps FOR INSERT WITH CHECK (owner_uuid = current_owner_uuid());
CREATE POLICY insert_organization ON apps FOR INSERT WITH CHECK (current_owner_has_organization_permission(organization_uuid, 'CREATE_APP'));
GRANT INSERT ON apps TO asyncy_visitor;

CREATE POLICY update_own ON apps FOR UPDATE WITH CHECK (owner_uuid = current_owner_uuid());
CREATE POLICY update_organization ON apps FOR UPDATE WITH CHECK (current_owner_has_organization_permission(organization_uuid, 'CREATE_APP'));
GRANT UPDATE ON apps TO asyncy_visitor;

---

ALTER TABLE app_dns ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_app ON app_dns FOR SELECT USING (EXISTS(SELECT 1 FROM apps WHERE apps.uuid = app_dns.app_uuid));
GRANT SELECT ON app_dns TO asyncy_visitor;
