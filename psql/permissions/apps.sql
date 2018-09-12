ALTER TABLE apps ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_own ON apps FOR SELECT USING (owner_uuid = current_owner_uuid());
CREATE POLICY select_organization ON apps FOR SELECT USING (organization_uuid = ANY (current_owner_organization_uuids()));
GRANT SELECT ON apps TO asyncy_visitor;

---

ALTER TABLE app_dns ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_app ON app_dns FOR SELECT USING (EXISTS(SELECT 1 FROM apps WHERE apps.uuid = app_dns.app_uuid));
GRANT SELECT ON app_dns TO asyncy_visitor;
