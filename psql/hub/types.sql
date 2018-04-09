CREATE TYPE service as enum ('github');

CREATE TYPE login_type as enum('api', 'login');

CREATE TYPE release_state as enum('active', 'rolling-up', 'rolling-back', 'a/b');

CREATE TYPE build_state as enum('queued', 'building', 'success', 'failure', 'error');
