CREATE TYPE token_type as enum('api', 'login', 'app');

CREATE TABLE tokens(
  uuid                    uuid default uuid_generate_v4() primary key,
  owner_uuid              uuid references owners on delete cascade not null,
  type                    token_type not null,
  name                    title,
  expires                 timestamp,  -- check must be future
  permissions             permission[]
) without oids;
COMMENT on column tokens.uuid is 'The token itself that is shared with the user.';
COMMENT on column tokens.type is 'User login, api token, or application link.';
COMMENT on column tokens.name is 'A custom title for the login.';
COMMENT on column tokens.expires is 'Date the token should expire on.';
COMMENT on column tokens.permissions is 'List of permissions this token has privileges too.';

create index token_owners on tokens (owner_uuid);
