-- Note that although we reference the search_terms_to_tsquery function twice
-- here, PostgreSQL will notice it's IMMUTABLE and will (probably) memoize the
-- first call.

CREATE FUNCTION search_services(search_terms text) RETURNS SETOF services AS $$
  SELECT
    *
  FROM
    services
  WHERE
    services.tsvector @@ app_hidden.search_terms_to_tsquery('simple', search_terms)
  ORDER BY
    ts_rank(services.tsvector, app_hidden.search_terms_to_tsquery('simple', search_terms)) DESC,
    services.uuid DESC;
$$ LANGUAGE sql STABLE;
