CREATE TABLE services(
  id                         serial primary key,
  repo_id                    int references repos on delete cascade not null,
  alias                      alias unique,
  pull_url                   citext
);
COMMENT on column services.alias is 'The namespace reservation for the container';
COMMENT on column services.pull_url is 'Address where the container can be pulled from.';
