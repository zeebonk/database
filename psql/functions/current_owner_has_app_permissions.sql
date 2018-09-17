CREATE FUNCTION app_hidden.current_owner_has_app_permissions(app_uuid uuid, required_permission_slug text) RETURNS boolean AS $$
  SELECT EXISTS(
    SELECT 1
    FROM apps
    WHERE uuid = app_uuid
    AND (
      -- If the user owns the app then they have all permissions
      (owner_uuid IS NOT NULL AND owner_uuid = current_owner_uuid())
    OR
      -- If the user is organization owner
      (organization_uuid IS NOT NULL AND EXISTS(
        SELECT 1
        FROM organizations
        WHERE uuid = organization_uuid
        AND owner_uuid = current_owner_uuid()
        LIMIT 1
      ))
    OR
      (organization_uuid IS NOT NULL AND EXISTS(
        SELECT 1
        FROM team_permissions
        INNER JOIN team_members USING (team_uuid)
        INNER JOIN team_apps USING (team_uuid)
        WHERE team_apps.app_uuid = app_uuid
        AND team_members.owner_uuid = current_owner_uuid()
        AND required_permission_slug IN (team_permissions.permission_slug, 'ADMIN')
        LIMIT 1
      ))
    )
  );
$$ LANGUAGE sql STABLE STRICT SECURITY DEFINER SET search_path FROM CURRENT;

COMMENT ON FUNCTION app_hidden.current_owner_has_app_permissions(app_uuid uuid, required_permission_slug text) IS
  'If the current user has permission to the app using requested permission slug.';
