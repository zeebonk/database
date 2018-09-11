#! /bin/sh
set -e

# check $POSTGRES only in Alpha, since its used in the Asyncy Hub
if [ "$POSTGRES" = "yes" ]; then
  ./scripts/install/postgres.sh
fi

exit 0
