create table tokens(
  tokenid                 uuid default uuid_generate_v4() primary key,
  ownerid                 int references owners on delete cascade not null,
  type                    login_type not null,
  name                    text,
  expires                 timestamp,
  permissions             permission[]
);
comment on column tokens.tokenid is 'The token itself that is shared with the user.';
comment on column tokens.type is 'User login, api token, or application link.';
comment on column tokens.name is 'A custom title for the login.';
comment on column tokens.expires is 'Date the token should expire on.';
comment on column tokens.permissions is 'List of permissions this token has privileges too.';

create index token_owners on tokens (ownerid);
