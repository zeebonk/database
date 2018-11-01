CREATE TABLE app_runtime.subscriptions (
  uuid         uuid PRIMARY KEY,
  app_uuid     uuid REFERENCES apps.uuid ON DELETE CASCADE NOT NULL,
  container_id text                                        NOT NULL UNIQUE,
  url          text                                        NOT NULL,
  method       text                                        NOT NULL,
  payload      jsonb                                       NOT NULL,
  pod_name     text                                        NOT NULL
);