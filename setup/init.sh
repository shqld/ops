#!/bin/bash

set -eu

echo "(setup/init) Starting ..."

cd /ops

echo "Exporting constants as environment variables ..."
while read -r env ; do
  export ${env?}
done < setup/constants.env

sh setup/scripts/2_add_user.sh
sh setup/scripts/3_install_deps.sh
sh setup/scripts/5_init_user_menial.sh

sh src/docker/setup.sh

rm -r setup

echo "(setup/init) Done"
