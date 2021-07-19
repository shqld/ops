#!/bin/bash

set -eu

echo "(fetch_git_repo) Starting ..."

cd ~/setup

echo "(fetch_git_repo) Setup-ing ssh config"
cp -r .ssh ~
cp -r .ssh $HOME_SHO

echo "(fetch_git_repo) Testing connection to git@github.com ..."
ssh -T -oStrictHostKeyChecking=no git@github.com || echo "(fetch_git_repo) Skipping ..."

echo "(fetch_git_repo) Cloning github.com:shqld/ops ..."
rm -rf $OPS_DIR
git clone --depth 1 git@github.com:shqld/ops $OPS_DIR

echo "(fetch_git_repo) Done"

# echo "Downloading shqld/ops repo ..."
# curl -L -o shqld-ops.tar.gz \
#   -H "Authorization: token $GITHUB_TOKEN" \
#   -H "Accept: application/vnd.github.v3+json" \
#   https://api.github.com/repos/shqld/ops/tarball
# tar -xf shqld-ops.tar.gz

# SHQLD_DIR='~/github.com/shqld'
# mkdir -p $SHQLD_DIR

# echo "Moving repo to $SHQLD_DIR/ops ..."
# mv shqld-ops-* $SHQLD_DI/opsR
