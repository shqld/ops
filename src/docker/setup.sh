#!/bin/bash

set -eu

cd $OPS_DIR/src

echo "Installing docker ..."
yum install -y yum-utils 
yum-config-manager -y \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
yum -y remove podman # https://github.com/containers/podman/issues/4791
yum install -y docker-ce docker-ce-cli containerd.io

echo "Starting docker ..."
systemctl start docker

echo "Logging in to ghcr.io ..."
echo $GITHUB_PACKAGE_SHQLD_TOKEN | docker login -u shqld --password-stdin ghcr.io

echo "Starting docker swarm ..."
docker swarm init || echo "docker swarm has already been started"

REPO=shqld/dev STACK_NAME=shqld-dev VERSION=latest sh docker/create_stack.sh
