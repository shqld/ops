OPS_ROOT := /ops

setup: .task/docker-login .task/vol-dirs up

up: .task/vol-dirs
	@docker stack up services -c $(OPS_ROOT)/services/docker-compose.yaml

down:
	@docker stack down services

.task/vol-dirs: docker-compose.yaml
	@cat docker-compose.yaml | grep "source: " | cut -d':' -f2 | xargs -n1 mkdir -p
	@mkdir -p .task; touch .task/vol-dirs

.task/docker-login:
	@test -n "${DOCKER_REGISTRY_TOKEN}"
	@echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	@mkdir -p .task; touch .task/docker-login
