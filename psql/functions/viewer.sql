CREATE FUNCTION viewer() RETURNS owners AS $$
  SELECT * FROM owners WHERE uuid = current_owner_uuid();
$$ LANGUAGE sql STABLE SET search_path FROM CURRENT;
