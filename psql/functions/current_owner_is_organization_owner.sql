CREATE FUNCTION app_hidden.current_owner_is_organization_owner(organization_uuid uuid) RETURNS boolean AS $$
  SELECT true
  FROM organizations
  WHERE uuid = organization_uuid
  AND owner_uuid = current_owner_uuid()
  LIMIT 1;
$$ LANGUAGE sql STABLE SECURITY DEFINER SET search_path FROM CURRENT;
