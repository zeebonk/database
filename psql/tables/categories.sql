CREATE TABLE categories(
  uuid                  uuid default uuid_generate_v4() primary key,
  title                 title,
  icon                  citext,
  type                  category_type not null
);
COMMENT on table categories is 'Collection of services.';

INSERT INTO categories (title, icon, type) values
  ('Authentication', null, 'SERVICE'),
  ('CMS', null, 'SERVICE'),
  ('Database', null, 'SERVICE'),
  ('Logging', null, 'SERVICE'),
  ('Memory Store', null, 'SERVICE'),
  ('Messaging', null, 'SERVICE'),
  ('Monitoring', null, 'SERVICE'),
  ('Optimization', null, 'SERVICE'),
  ('Search', null, 'SERVICE'),
  ('Social Media', null, 'SERVICE'),
  ('Video Processing', null, 'SERVICE'),
  ('Image Processing', null, 'SERVICE'),
  ('Text Processing', null, 'SERVICE'),
  ('Machine Learning', null, 'SERVICE'),
  ('Programming Languages', null, 'SERVICE'),
  ('Developer Tools', null, 'SERVICE'),
  ('IoT', null, 'SERVICE'),
  ('Worker', null, 'SERVICE'),
  ('Sorting', null, 'FUNCTION'),
  ('Filtering', null, 'FUNCTION'),
  ('Strings', null, 'FUNCTION');
