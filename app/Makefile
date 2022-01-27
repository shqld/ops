OPS_ROOT := /ops

setup: up

up: .task/docker-login
	@docker stack up app -c $(OPS_ROOT)/app/docker-compose.yaml

down:
	@docker stack down app

.task/docker-login:
	@test -n "${DOCKER_REGISTRY_TOKEN}"
	@echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	@mkdir -p .task; touch .task/docker-login
