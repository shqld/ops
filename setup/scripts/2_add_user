#!/bin/bash

set -eu

echo "(add_user) Starting ..."

cd /ops

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

echo "Adding user(sho) to group(docker, ops) ..."
usermod -a -G docker sho
usermod -a -G ops sho

if grep "sho ALL=(root)" < /etc/sudoers; then
  echo "Skipping adding sho to sudoers ..."
else
  echo "Adding sho to sudoers ..."
  echo "
sho ALL=(root) $(which yum)
sho ALL=(root) $(which git)
sho ALL=(root) $(which systemctl)
  " >> /etc/sudoers
fi

echo "(add_user) Done"
