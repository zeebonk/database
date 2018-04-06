#! /bin/sh
set -e

cli_args="-h ${POSTGRES_HOST:-postgres} -U ${POSTGRES_USER:-postgres} -p ${POSTGRES_PORT:-5432} -v ON_ERROR_STOP=1"

res=$(psql $cli_args -Atc "select datname from pg_database where datistemplate = false and datname='app';")

if [ "$res" = "" ]; then

  echo '===> Setting up PostgreSQL'

  psql $cli_args -c 'create database app;'
  psql $cli_args -d app -f ../psql/app/main.sql

  psql $cli_args -c 'create database hub;'
  psql $cli_args -d hub -f ../psql/hub/main.sql

  psql $cli_args -c 'create database grafana;'

fi
