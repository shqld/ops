OPS_ROOT := /ops

setup: .task/docker-login up

up:
	@docker-compose -f $(OPS_ROOT)/services/docker-compose.yaml up -d
	make .task/restart

down:
	@docker-compose -f $(OPS_ROOT)/services/docker-compose.yaml down

restart: .task/restart

.task/restart: .task/restart/nginx .task/restart/varnish .task/restart/www .task/restart/me

.task/restart/nginx: nginx/nginx.conf
	@docker-compose -f $(OPS_ROOT)/services/docker-compose.yaml restart nginx
	@mkdir -p .task/restart; touch .task/restart/nginx

.task/restart/varnish: varnish/default.vcl varnish/chunks/*.vcl
	@docker-compose -f $(OPS_ROOT)/services/docker-compose.yaml restart varnish
	@mkdir -p .task/restart; touch .task/restart/varnish

.task/restart/www:
	@docker-compose -f $(OPS_ROOT)/services/docker-compose.yaml restart www
	@mkdir -p .task/restart; touch .task/restart/www

.task/restart/me:
	@docker-compose -f $(OPS_ROOT)/services/docker-compose.yaml restart me
	@mkdir -p .task/restart; touch .task/restart/me

.task/docker-login:
	@test -n "${DOCKER_REGISTRY_TOKEN}"
	@echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	@mkdir -p .task; touch .task/docker-login
