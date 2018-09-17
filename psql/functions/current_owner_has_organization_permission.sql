CREATE FUNCTION app_hidden.current_owner_has_organization_permission(organization_uuid uuid, required_permission_slug text) RETURNS boolean AS $$
  SELECT EXISTS(
    SELECT 1
    FROM organizations
    WHERE uuid = organization_uuid
    AND owner_uuid = current_owner_uuid()
    LIMIT 1
  ) OR EXISTS(
    SELECT 1
    FROM teams
    INNER JOIN team_members ON (teams.uuid = team_members.team_uuid)
    INNER JOIN team_permissions ON (teams.uuid = team_permissions.team_uuid)
    WHERE teams.organization_uuid = organization_uuid
    AND team_members.owner_uuid = current_owner_uuid()
    AND required_permission_slug = team_permissions.permission_slug
    LIMIT 1
  );
$$ LANGUAGE sql STABLE STRICT SECURITY DEFINER SET search_path FROM CURRENT;

COMMENT ON FUNCTION app_hidden.current_owner_has_organization_permission(organization_uuid uuid, required_permission_slug text) IS
  'If the current user has requested permission slug.';
