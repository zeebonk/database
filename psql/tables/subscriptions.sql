CREATE TABLE app_runtime.subscriptions (
  uuid             uuid PRIMARY KEY,
  app_uuid         uuid REFERENCES apps (uuid) ON DELETE CASCADE NOT NULL,
  url              text                                          NOT NULL,
  method           http_method                                   NOT NULL,
  payload          jsonb                                         NOT NULL,
  k8s_container_id text                                          NOT NULL,
  k8s_pod_name     text                                          NOT NULL
);
