ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_all ON categories FOR SELECT USING (true);
GRANT SELECT ON categories TO asyncy_visitor;
