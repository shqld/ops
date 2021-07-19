#!/bin/bash

set -eu

cd $OPS_DIR/src

REPO=$REPO VERSION=$SERVICE_VERSION commands/sho/docker-pull
IMAGE="ghcr.io/shqld/dev/app:$SERVICE_VERSION" NAME=$SERVICE_NAME commands/sho/docker-service-update
