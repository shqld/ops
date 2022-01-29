OPS_ROOT := /ops

setup: .task/docker-login up

up:
	@docker-compose -f $(OPS_ROOT)/services/docker-compose.yaml up -d

down:
	@docker-compose -f $(OPS_ROOT)/services/docker-compose.yaml down

.task/docker-login:
	@test -n "${DOCKER_REGISTRY_TOKEN}"
	@echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	@mkdir -p .task; touch .task/docker-login
