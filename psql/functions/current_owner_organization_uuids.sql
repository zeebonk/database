CREATE FUNCTION current_owner_organization_uuids() RETURNS uuid[] AS $$
  SELECT array_agg(DISTINCT organization_uuid)
  FROM members
  INNER JOIN teams ON (members.team_uuid = teams.uuid)
  WHERE members.owner_uuid = current_owner_uuid();
$$ LANGUAGE sql STABLE SET search_path FROM CURRENT;
