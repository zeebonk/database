CREATE TABLE app_public.tokens(
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid references owners on delete cascade not null,
  type                    token_type not null,
  name                    title,
  expires                 timestamptz not null default NOW() + INTERVAL '25 years' CHECK (expires > NOW()),
  permissions             text[]
);
COMMENT on column tokens.uuid is 'The token itself that is shared with the user.';
COMMENT on column tokens.type is 'User login, api token, or application link.';
COMMENT on column tokens.name is 'A custom title for the login.';
COMMENT on column tokens.expires is 'Date the token should expire on.';
COMMENT on column tokens.permissions is 'List of permission slugs this token has privileges too.';

CREATE INDEX token_owner_uuid_fk on tokens (owner_uuid);

CREATE TRIGGER _100_insert_assert_permissions_exist before insert on tokens
  for each row
  when (array_length(new.permissions, 1) > 0)
  execute procedure assert_permissions_exist();

CREATE TRIGGER _100_update_assert_permissions_exist before update on tokens
  for each row
  when (new.permissions is distinct from old.permissions and array_length(new.permissions, 1) > 0)
  execute procedure assert_permissions_exist();

CREATE TABLE app_private.token_secrets (
  token_uuid              uuid primary key references app_public.tokens,
  secret                  text not null default encode(gen_random_bytes(16), 'base64') unique
);

COMMENT ON COLUMN app_private.token_secrets.secret IS '16 bytes, encoded as base64; at least as much entropy as a UUID - risk of collisions is vanishingly small.';

CREATE FUNCTION app_hidden.tg_tokens__insert_secret() RETURNS trigger AS $$
BEGIN
  INSERT INTO app_private.token_secrets(token_uuid) VALUES (NEW.uuid);
  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL VOLATILE SECURITY DEFINER SET search_path FROM CURRENT;

CREATE TRIGGER _500_insert_secret AFTER INSERT ON tokens FOR EACH ROW EXECUTE PROCEDURE app_hidden.tg_tokens__insert_secret();
