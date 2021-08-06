#!/bin/bash

set -eu

echo "(setup/init) Starting ..."

cd ~

echo "Exporting constants as environment variables ..."
export "$(xargs < setup/constants.env)"

sh setup/scripts/2_add_user.sh
sh setup/scripts/3_install_deps.sh
sh setup/scripts/4_fetch_git_repo.sh
sh setup/scripts/5_add_user_daemon.sh

sh $OPS_DIR/src/docker/setup.sh

rm -r setup

echo "(setup/init) Done"
