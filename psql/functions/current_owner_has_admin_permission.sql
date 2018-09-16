CREATE FUNCTION app_hidden.current_owner_has_admin_permission(organization_uuid uuid) RETURNS boolean AS $$
  SELECT true
  FROM team_members
  INNER JOIN team_permissions on (team_members.team_uuid = team_permissions.team_uuid)
  WHERE team_members.owner_uuid = current_owner_uuid()
  AND team_permissions.permission_slug = 'ADMIN'
  LIMIT 1;
$$ LANGUAGE sql STABLE SECURITY DEFINER SET search_path FROM CURRENT;
