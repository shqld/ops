OPS_ROOT := /ops

setup: up

up:
	@docker stack up system -c $(OPS_ROOT)/system/docker-compose.yaml

down:
	@docker stack down system
