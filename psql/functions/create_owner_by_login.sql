CREATE FUNCTION app_private.create_owner_by_login(
    service app_public.git_service,
    service_id text,
    username username,
    name text,
    email email,
    oauth_token text
) RETURNS json AS $$
  DECLARE _owner_uuid uuid DEFAULT NULL;
  DECLARE _owner_service_uuid uuid DEFAULT NULL;
  DECLARE _token_uuid uuid DEFAULT NULL;
  BEGIN

    -- TODO IF (service, username) conflict THEN need to truncate the other username
    -- TODO IF (service, service_id) conflict THEN need to update the username

    SELECT uuid, owner_uuid
      INTO _owner_service_uuid, _owner_uuid
      FROM owner_services o
      WHERE o.service=$1
        AND o.service_id=$2
      LIMIT 1;

    IF _owner_uuid IS NOT NULL THEN

      -- update their oauth token
      UPDATE app_private.owner_service_secrets
        SET oauth_token=$6
        WHERE owner_service_uuid=_owner_service_uuid;

      -- select an existing login token
      -- TODO create new tokens based on the IP/source of login
      SELECT uuid into _token_uuid
        FROM tokens
        WHERE owner_uuid=_owner_uuid
          AND type='LOGIN'
        LIMIT 1;

    ELSE

      INSERT INTO owners (is_user, username, name)
        VALUES (true, $3, $4)
        RETURNING uuid into _owner_uuid;

      INSERT INTO owner_services (owner_uuid, service, service_id, username)
        VALUES (_owner_uuid, $1, $2, $3)
        RETURNING uuid into _owner_service_uuid;

      INSERT INTO owner_emails (owner_uuid, email, is_verified)
        VALUES (_owner_uuid, $5, true);

      INSERT INTO app_private.owner_service_secrets (owner_service_uuid, oauth_token)
        VALUES (_owner_service_uuid, $6);

    END IF;

    IF _token_uuid IS NULL THEN

      INSERT INTO tokens (owner_uuid, type, name, expires)
        VALUES (_owner_uuid, 'LOGIN', 'CLI Login', current_timestamp + '3 months'::interval)
        RETURNING uuid into _token_uuid;

    ELSE

      UPDATE tokens
        SET expires=(current_timestamp + '3 months'::interval)
        WHERE owner_uuid=_owner_uuid
          AND type='LOGIN';

    END IF;

    RETURN json_build_object('owner_uuid', _owner_uuid,
                             'token_uuid', _token_uuid);

  END;
$$ LANGUAGE plpgsql VOLATILE SET search_path FROM CURRENT;
