#! /bin/sh
set -e

echo '

             _____  __     __  _   _    _____  __     __
    /\      / ____| \ \   / / | \ | |  / ____| \ \   / /
   /  \    | (___    \ \_/ /  |  \| | | |       \ \_/ /
  / /\ \    \___ \    \   /   |     | | |        \   /
 / /  \ \   ____) |    | |    | |\  | | |____     | |
/_/    \_\ |_____/     |_|    |_| \_|  \_____|    |_|

            Write stories, then code.

'


# check $POSTGRES only in Alpha, since its used in the Asyncy Hub
if [ "$POSTGRES" = "yes" ]; then
  ./scripts/install/postgres.sh
fi

# Parse Asyncy's backend Stories
echo '===> Preparing Asyncy backend'
storyscript parse -j ./stories > /app/stories.json

# Start the primary Engine
echo '===> Starting primary Engine'
# [TODO]

# Run
echo '===> Running Flask server'
python ./server/app.py
