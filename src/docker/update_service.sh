#!/bin/bash

set -eu

cd /ops/src

REPO=$REPO VERSION=$SERVICE_VERSION commands/sho/docker-pull
IMAGE="ghcr.io/shqld/dev/app:$SERVICE_VERSION" NAME=$SERVICE_NAME commands/sho/docker-service-update
