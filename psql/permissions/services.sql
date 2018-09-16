ALTER TABLE services ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_public ON services FOR SELECT USING (public);
CREATE POLICY select_own ON services FOR SELECT USING (owner_uuid = current_owner_uuid());
CREATE POLICY select_organization ON services FOR SELECT USING (organization_uuid = ANY (current_owner_organization_uuids()));
GRANT SELECT ON services TO asyncy_visitor;

---

ALTER TABLE service_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_tag ON service_tags FOR SELECT USING (EXISTS(SELECT 1 FROM services WHERE services.uuid = service_tags.service_uuid));
GRANT SELECT ON service_tags TO asyncy_visitor;

---

ALTER TABLE service_categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_all ON service_categories FOR SELECT USING (true);
GRANT SELECT ON service_categories TO asyncy_visitor;
