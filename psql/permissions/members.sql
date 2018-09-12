ALTER TABLE members ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_team_member ON members FOR SELECT USING (team_uuid = ANY (current_owner_team_uuids()));
GRANT SELECT ON members TO asyncy_visitor;
