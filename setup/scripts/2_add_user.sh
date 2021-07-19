#!/bin/bash

set -eu

echo "(add_user) Starting ..."

cd ~/setup

if grep sho < /etc/group; then
  echo "Skipping adding user(sho) ..."
else
  echo "Adding user(sho) ..."
  useradd sho
  echo $USER_PASSWD_SHO | passwd sho --stdin
fi

if grep docker < /etc/group; then
  echo "Skipping adding group(docker) ..."
else
  echo "Adding group(docker) ..."
  groupadd docker
fi

echo "Adding user(sho) to group(docker ) ..."
usermod -a -G docker sho

echo "Adding sho to sudoers ..."
echo "
sho ALL=(root) $(which yum)
sho ALL=(root) $(which git)
sho ALL=(root) $(which systemctl)
" >> /etc/sudoers

echo "(add_user) Done"
