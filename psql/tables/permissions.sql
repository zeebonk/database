CREATE TABLE permissions(
  uuid                       uuid default uuid_generate_v4() primary key,
  title                      title not null
);
COMMENT on column permissions.title is 'Short description of the permission.';


CREATE FUNCTION assert_permissions_exist() returns trigger as $$
begin
  -- TODO check one dimention
  -- TODO  that all exist in permissions table
 return new;
end;
$$ language plpgsql;
