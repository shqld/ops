OPS_ROOT := /ops

setup: .task/vol-dirs up

up: .task/vol-dirs
	@docker stack up system -c $(OPS_ROOT)/system/docker-compose.yaml

down:
	@docker stack down system

.task/vol-dirs: docker-compose.yaml
	@cat docker-compose.yaml | grep "source: " | cut -d':' -f2 | xargs -n1 mkdir -p
	@mkdir -p .task; touch .task/vol-dirs
