CREATE FUNCTION app_hidden.current_owner_has_app_permissions(app_uuid uuid, required_permission_slugs text[] = array[]::text[]) RETURNS boolean AS $$
  SELECT EXISTS(
    SELECT 1
    FROM apps
    WHERE uuid = app_uuid
    AND (
      -- If the user owns the app then they have all permissions
      owner_uuid = current_owner_uuid()
    OR
      organization_uuid = ANY(current_owner_organization_uuids(required_permission_slugs))
    )
  );
$$ LANGUAGE sql STABLE SECURITY DEFINER SET search_path FROM CURRENT;
