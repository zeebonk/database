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


# Install
#./scripts/install/postgres.sh

# Parse Asyncy's backend Stories
echo '===> Preparing Asyncy backend'
mkdir /app
storyscript parse --join ./stories > /app/stories.json

# Start the primary Engine
echo '===> Starting primary Engine'
# [TODO]

# Run
echo '===> Running Flask server'
python ./server/app.py
