CUR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OPS := $(realpath $(CUR)/..)

setup: .task/docker-login up

up:
	@docker-compose up -d
	make .task/restart

down:
	@docker-compose down

restart: .task/restart

.task/restart: .task/restart/nginx .task/restart/varnish .task/restart/dev .task/restart/me

.task/restart/nginx: nginx/nginx.conf
	@docker-compose restart nginx
	@mkdir -p .task/restart; touch .task/restart/nginx

.task/restart/varnish: varnish/default.vcl varnish/chunks/*.vcl
	@docker-compose restart varnish
	@mkdir -p .task/restart; touch .task/restart/varnish

.task/restart/dev:
	@docker-compose restart dev
	@mkdir -p .task/restart; touch .task/restart/dev

.task/restart/me:
	@docker-compose restart me
	@mkdir -p .task/restart; touch .task/restart/me

.task/docker-login:
	@test -v DOCKER_REGISTRY_TOKEN || (echo "DOCKER_REGISTRY_TOKEN not set" && exit 1)
	@echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	@mkdir -p .task; touch .task/docker-login
