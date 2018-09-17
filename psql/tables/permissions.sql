CREATE TABLE permissions(
  slug                       text not null check (slug ~ '^[A-Z_]+$') primary key,
  title                      title not null
);
COMMENT on column permissions.title is 'Short description of the permission.';

INSERT INTO permissions (slug, title) VALUES
  ('ADMIN', 'Organization administrator'),
  ('BILLING', 'Billing'),
  ('CREATE_APP', 'Create application'),
  ('CREATE_RELEASE', 'Create release');


CREATE FUNCTION assert_permissions_exist() returns trigger as $$
begin
  if array_ndims(NEW.permissions) > 1 then
    raise exception 'Invalid permissions, expected one-dimensional array' using errcode = 'SECPD';
  end if;
  if exists(
    select 1
    from unnest(NEW.permissions) pslug
    left join permissions on (pslug = permissions.slug)
    where permissions.slug is null
  ) then
    raise exception 'Invalid permissions, permission unrecognised' using errcode = 'SECPX';
  end if;
 return new;
end;
$$ language plpgsql SET search_path FROM CURRENT;
