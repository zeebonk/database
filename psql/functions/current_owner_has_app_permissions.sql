CREATE FUNCTION app_hidden.current_owner_has_app_permissions(app_uuid uuid, required_permission_slugs text[] = array[]::text[]) RETURNS boolean AS $$
  SELECT true
  FROM apps
  WHERE uuid = app_uuid
  AND (
    -- If the user owns the app then they have all permissions
    owner_uuid = current_owner_uuid()
  OR
    -- If the user is an Admin of the organization
    current_owner_is_organization_owner(organization_uuid)
  OR
    (
      SELECT true
      FROM teams
      INNER JOIN team_members ON (teams.uuid = team_members.team_uuid)
      INNER JOIN team_apps ON (teams.uuid = team_apps.team_uuid)
      INNER JOIN team_permissions ON (teams.uuid = team_permissions.team_uuid)
      WHERE team_apps.app_uuid = app_uuid
      AND team_members.owner_uuid = current_owner_uuid()
      AND required_permission_slugs @> ARRAY[team_permissions.permission_slug]
      LIMIT 1
    )
  );
$$ LANGUAGE sql STABLE SECURITY DEFINER SET search_path FROM CURRENT;

COMMENT ON FUNCTION app_hidden.current_owner_has_app_permissions(app_uuid uuid, required_permission_slugs text[]) IS
  'If the current user has permission to the app using requested permission slug.';
