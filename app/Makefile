DOCKER_CONFIG_PATH = "$HOME/.docker/config.json"

.PHONY: update-all
update-all:
	@set -eu
	@grep 'ghcr.io' < $(DOCKER_CONFIG_PATH) || \
		echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	@export CONTAINER_UID=$(id -u app)
	docker-compose -f /ops/app/docker-compose.yaml pull
	docker stack up shqld --compose-file /ops/app/docker-compose.yaml --prune

.PHONY: update-%
update-%:
	@set -eu
	@grep 'ghcr.io' < $(DOCKER_CONFIG_PATH) || \
		echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	@export CONTAINER_UID=$(id -u app)
	docker service update "shqld_${@:update-%=%}" --with-registry-auth --force
