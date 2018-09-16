psql ${DB:-asyncy} -1AXtv ON_ERROR_STOP=1 -f psql/reset_and_seed.sql
