CREATE FUNCTION owner_username_conflict() RETURNS TRIGGER AS $$
DECLARE
  _username username;
  _n int default 0;
BEGIN

  _username = NEW.username;

  LOOP
    IF EXISTS (SELECT 1 FROM owners WHERE username=_username limit 1) THEN
      IF _n > 0 THEN
        _username = rtrim(_username, ('-' || _n)) || '-' || (_n + 1);
      ELSE
        _username = _username || '-' || (_n + 1);
      END IF;
      _n = _n + 1;
    ELSE
      NEW.username = _username;
      EXIT;
    END IF;
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER _100_insert_owner_username_conflict
  BEFORE INSERT ON owners
  FOR EACH ROW
  EXECUTE PROCEDURE owner_username_conflict();
