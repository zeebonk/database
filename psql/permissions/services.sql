ALTER TABLE services ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_public ON services FOR SELECT USING (public);
CREATE POLICY select_own ON services FOR SELECT USING (owner_uuid = current_owner_uuid());
CREATE POLICY select_organization ON services FOR SELECT USING (organization_uuid = ANY (current_owner_organization_uuids()));
GRANT SELECT ON services TO asyncy_visitor;
