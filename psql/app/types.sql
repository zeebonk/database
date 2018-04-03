create type service as enum ('github');

create type login_type as enum('api', 'login');

create type release_state as enum('active', 'rolling-up', 'rolling-back', 'a/b');

create type build_state as enum('queued', 'building', 'success', 'failure', 'error');

create type permission as enum('story:kill');
