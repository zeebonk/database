ALTER TABLE builds ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_repo_visible ON builds FOR SELECT USING (EXISTS(SELECT 1 FROM repos WHERE repos.uuid = builds.repo_uuid));
GRANT SELECT ON builds TO asyncy_visitor;
