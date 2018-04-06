create table logins(
  loginid                 serial primary key,
  ownerid                 int references owners on delete cascade not null,
  type                    login_type not null,
  name                    text,  -- name of the API token
  token                   uuid unique default uuid_generate_v4() not null
);
