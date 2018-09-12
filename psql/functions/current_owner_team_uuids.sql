CREATE FUNCTION current_owner_team_uuids() RETURNS uuid[] AS $$
  SELECT array_agg(team_uuid) FROM members WHERE owner_uuid = current_owner_uuid();
$$ LANGUAGE sql STABLE SET search_path FROM CURRENT;
