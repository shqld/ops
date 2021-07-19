#!/bin/bash

set -eu

cd $OPS_DIR

echo "(add_user_menial) Starting ..."

if grep menial < /etc/group; then
  echo "Skipping adding user(menial) ..."
else
  echo "Adding user(menial) ..."
  useradd menial
fi

echo "Modifying sho's commands ..."
chmod +x src/commands/sho/*

echo "Adding permissions to user(menial) ..."
for command in src/commands/sho/*; do
  echo "menial ALL=(sho) $OPS_DIR/$command" >> /etc/sudoers
done

cd /home/menial

echo "Setting ssh config ..."
mkdir .ssh
chmod 700 .ssh
echo $AUTHORIZED_KEY_MENIAL > .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
chown menial -R .ssh

echo "
Match User menial
  PasswordAuthentication no
  PubkeyAuthentication yes
  AuthorizedKeysFile /home/menial/.ssh/authorized_keys
" >> /etc/ssh/sshd_config

echo "(add_user_menial) Done"
