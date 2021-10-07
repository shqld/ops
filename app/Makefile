DOCKER_CONFIG_PATH = "$HOME/.docker/config.json"

app-update:
	@set -eu
	@grep 'ghcr.io' < $(DOCKER_CONFIG_PATH) || \
		echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	# @export CONTAINER_UID=$(id -u app)
	docker-compose -f /ops/app/docker-compose.yaml up -d
