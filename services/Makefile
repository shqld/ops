.PHONY: deploy-www
deploy-www:
	@set -eu
	@echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	docker stack deploy --compose-file /ops/services/www/docker-compose.yaml --with-registry-auth www