CREATE FUNCTION app_hidden.search_terms_to_tsquery(config regconfig, search_terms text) RETURNS tsquery AS $$
DECLARE
  v_sanitised text;
  v_sanitised_and_trimmed text;
  v_joined_with_ampersands text;
BEGIN
  v_sanitised = lower(regexp_replace(
    search_terms,
    '[^\d\w\s]',
    ' ',
    'g'
  ));
  v_sanitised_and_trimmed = regexp_replace(
    v_sanitised,
    '(^[^\d\w]*|[^\d\w]*$)',
    '',
    'g'
  );
  v_joined_with_ampersands = regexp_replace(v_sanitised_and_trimmed, '\s+', ' & ', 'g');
  RETURN to_tsquery(config, v_joined_with_ampersands || ':*');
END;
$$ LANGUAGE plpgsql IMMUTABLE;


COMMENT ON FUNCTION app_hidden.search_terms_to_tsquery(config regconfig, search_terms text) IS
  E'Converts a web search term to a tsquery that can be used for FTS. This is a poor approximation for websearch_to_tsquery that''s coming in PG11. The final term is treated as a prefix search, all other terms are full matches.';
