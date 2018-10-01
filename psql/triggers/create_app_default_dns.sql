CREATE FUNCTION apps_create_dns() returns trigger as $$
  DECLARE dns hostname default null;
  BEGIN

    BEGIN
      INSERT INTO app_dns (hostname, app_uuid, is_validated)
        VALUES (convert_to_hostname(new.name), new.uuid, true)
        ON CONFLICT (hostname) DO NOTHING
        RETURNING hostname into dns;

      IF dns IS NOT NULL THEN
        RETURN new;
      END IF;
    EXCEPTION WHEN check_violation THEN
      -- Do nothing
    END;

    LOOP
      INSERT INTO app_dns (hostname, app_uuid, is_validated)
        VALUES (generate_awesome_word()::hostname, new.uuid, true)
        ON CONFLICT (hostname) DO NOTHING
        RETURNING hostname into dns;

      IF dns IS NOT NULL THEN
        RETURN new;
      END IF;
    END LOOP;

  END;
$$ language plpgsql security definer SET search_path FROM CURRENT;

CREATE TRIGGER _101_apps_create_dns after insert on apps
  for each row execute procedure apps_create_dns();
