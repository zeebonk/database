ALTER TABLE permissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_all ON permissions FOR SELECT USING (true);
GRANT SELECT ON permissions TO asyncy_visitor;

-- Do not grant INSERT, UPDATE, DELETE - these permissions are managed by the system, not users.
