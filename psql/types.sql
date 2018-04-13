CREATE TYPE service as enum('github');

CREATE DOMAIN title as citext
  CHECK ( LENGTH(VALUE) > 1 AND LENGTH(VALUE) < 25 AND VALUE ~ '^\w[\w\-\.\s]{2,44}$' );

CREATE DOMAIN username as text
  CHECK ( LENGTH(VALUE) >= 3 AND LENGTH(VALUE) <= 40 AND VALUE ~ '^[a-z\d](?:[a-z\d]|-(?=[a-z\d])){0,38}$' );

CREATE DOMAIN hostname as text
  CHECK ( LENGTH(VALUE) > 7 AND LENGTH(VALUE) < 25 AND VALUE ~ '^((\*|[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$' );

CREATE DOMAIN email AS citext
  CHECK ( LENGTH(VALUE) >= 5 AND LENGTH(VALUE) <= 512 AND VALUE ~ '^[^@]+@[^@]+\.[^@]+$' );

CREATE DOMAIN sha as citext
  CHECK ( LENGTH(VALUE) = 40 AND VALUE ~ '^\w{40}$' );

CREATE DOMAIN alias as citext
  CHECK ( LENGTH(VALUE) > 1 AND LENGTH(VALUE) < 25 AND VALUE ~ '^[\w\-\.]{2,24}$' );

CREATE DOMAIN url as citext
  CHECK ( LENGTH(VALUE) <= 256 and VALUE ~ '^https?://');
