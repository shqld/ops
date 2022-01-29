OPS_ROOT := /ops

setup: .task/docker-login up

up:
	@docker stack up services -c $(OPS_ROOT)/services/docker-compose.yaml

down:
	@docker stack down services

.task/docker-login:
	@test -n "${DOCKER_REGISTRY_TOKEN}"
	@echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	@mkdir -p .task; touch .task/docker-login
