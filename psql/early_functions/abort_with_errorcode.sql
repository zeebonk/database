CREATE FUNCTION abort_with_errorcode() RETURNS trigger AS $$
BEGIN
  RAISE EXCEPTION 'ERROR %: %', TG_ARGV[0], TG_ARGV[1] USING errcode = TG_ARGV[0];
END;
$$ LANGUAGE plpgsql;
