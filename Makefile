DB ?= asyncy
reset:
	psql ${DB} -1AXtv ON_ERROR_STOP=1 -f psql/reset_and_seed.sql

watch:
	# npm install -g nodemon
	nodemon --watch psql ${DB} -e sql -x ./reset_and_seed.sh

psql:
	psql "options=--search_path=app_public,app_hidden,app_private,public dbname=${DB}"
