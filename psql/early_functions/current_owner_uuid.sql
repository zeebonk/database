CREATE FUNCTION app_hidden.current_owner_uuid() RETURNS uuid AS $$
  SELECT nullif(current_setting('jwt.claims.owner_uuid', true), '')::uuid;
$$ LANGUAGE sql STABLE SET search_path FROM CURRENT;
