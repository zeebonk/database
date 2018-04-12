CREATE TYPE service as enum('github');

CREATE TYPE permission as enum('story:kill');

CREATE DOMAIN title as text
  CHECK ( VALUE ~ '^\w[\w\-\.\s]{2,44}$' );

CREATE DOMAIN username as text
  CHECK ( LENGTH(VALUE) >= 3 AND LENGTH(VALUE) <= 40 AND VALUE ~ '^[a-z\d](?:[a-z\d]|-(?=[a-z\d])){0,38}$' );

CREATE DOMAIN hostname as text
  CHECK ( VALUE ~ '^((\*|[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$' );

CREATE DOMAIN email AS citext
  CHECK ( LENGTH(VALUE) >= 5 AND LENGTH(VALUE) <= 512 AND VALUE ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

CREATE DOMAIN sha as citext
  CHECK ( VALUE ~ '^\w{40}$' );

CREATE DOMAIN alias as citext
  CHECK ( VALUE ~ '^[\w\-\.]{2,24}$' );
