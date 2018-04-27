CREATE TABLE permissions(
  uuid                       uuid default uuid_generate_v4() primary key,
  title                      title not null
);
COMMENT on column permissions.title is 'Short description of the permission.';


CREATE FUNCTION assert_permissions_exist() returns trigger as $$
begin
  if array_ndims(NEW.permissions) > 1 then
    raise exception 'Invalid permissions, expected one-dimensional array' using errcode = 'SECPD';
  end if;
  if exists(
    select 1
    from unnest(NEW.permissions) puuid
    left join permissions on (puuid = permissions.uuid)
    where permissions.uuid is null
  ) then
    raise exception 'Invalid permissions, permission unrecognised' using errcode = 'SECPX';
  end if;
 return new;
end;
$$ language plpgsql;
