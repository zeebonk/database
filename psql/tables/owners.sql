CREATE TABLE owners(
  uuid                    uuid default uuid_generate_v4() primary key,
  service                 git_service not null default 'github'::git_service,
  service_id              citext not null,
  is_user                 boolean not null default true,
  username                username not null,
  name                    citext,
  github_installation_id  int default null
);
COMMENT on column owners.service is 'GitHub or another provider';
COMMENT on column owners.service_id is 'The providers unique id';
COMMENT on column owners.username is 'The handler name to the provider service';
COMMENT on column owners.name is 'A pretty organization name, UI visual only.';
COMMENT on column owners.github_installation_id is 'The installation id to the GitHub App';

CREATE UNIQUE INDEX owner_service_username on owners (service, username);
COMMENT on index owner_service_username is 'Can only have one service:username pair.';

CREATE UNIQUE INDEX owner_service_ids on owners (service, service_id);
COMMENT on index owner_service_ids is 'Can only have one service:service_id pair.';


CREATE TABLE owner_permissions (
  owner_uuid              uuid not null references owners on delete cascade,
  permission_uuid         uuid not null references permissions on delete restrict,
  PRIMARY KEY (owner_uuid, permission_uuid)
);

CREATE TABLE owner_emails (
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid not null references owners on delete cascade,
  email                   email not null,
  is_verified             boolean not null default false
);

CREATE UNIQUE INDEX ON owner_emails(owner_uuid, email); -- This index serves two purposes

CREATE TABLE owner_secrets (
  owner_uuid              uuid primary key references owners on delete cascade,
  oauth_token             varchar(45),
  email_verification_code varchar(30)
);
COMMENT on column owner_secrets.oauth_token is 'Stored as an encrypted string';

CREATE or replace FUNCTION createOwnerByLogin(
    service app_public.git_service,
    service_id text,
    username username,
    name text,
    email email,
    oauth_token text
) RETURNS uuid AS $$
  #variable_conflict use_variable
  DECLARE _owner_uuid uuid DEFAULT NULL;
  DECLARE _token_uuid uuid DEFAULT NULL;
  BEGIN

    -- TODO IF (service, username) conflict THEN need to truncate the other username
    -- TODO IF (service, service_id) conflict THEN need to update the username

    SELECT uuid into _owner_uuid
      FROM owners
      WHERE service=service
        AND username=username
      LIMIT 1;

    IF _owner_uuid IS NOT NULL THEN

      -- update their oauth token
      UPDATE owner_secrets
        SET oauth_token=oauth_token
        WHERE owner_uuid=_owner_uuid;

      SELECT uuid into _token_uuid
        FROM tokens
        WHERE owner_uuid=_owner_uuid
          AND type='LOGIN'
        LIMIT 1;

    ELSE
      
      INSERT INTO owners (service, service_id, is_user, username, name)
        VALUES (service, service_id, true, username, name)
        RETURNING uuid into _owner_uuid;

      INSERT INTO owner_emails (owner_uuid, email, is_verified)
        VALUES (_owner_uuid, email, true);
      
      UPDATE owner_secrets
        SET oauth_token=oauth_token
        WHERE owner_uuid=_owner_uuid;

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

    RETURN _token_uuid;
    
  END;
$$ LANGUAGE plpgsql VOLATILE SET search_path FROM CURRENT;
