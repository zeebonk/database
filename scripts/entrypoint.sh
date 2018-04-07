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
./scripts/install/postgres.sh
./scripts/install/kibana.sh


# Upgrade


# Run
echo '===> Running Flask server'
python ./server/app.py
