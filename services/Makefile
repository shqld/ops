include ../lib.mk

up: .task/docker-login .task/mkdir-volumes
	@docker compose up -d
	@$(MAKE) .task/restart

down:
	@docker compose down

restart: .task/restart

.task/restart: .task/restart/nginx .task/restart/varnish .task/restart/bind .task/restart/dev .task/restart/me

.task/restart/nginx: nginx/nginx.conf
	@docker compose restart nginx
	$(touch)

.task/restart/varnish: varnish/default.vcl varnish/chunks/*.vcl
	@docker compose restart varnish
	$(touch)

.task/restart/bind: bind/*.conf bind/zones/*
	@docker compose restart bind
	$(touch)

.task/restart/dev:
	@docker compose restart dev
	$(touch)

.task/restart/me:
	@docker compose restart me
	$(touch)

.task/docker-login:
	@test -v DOCKER_REGISTRY_TOKEN || (echo "DOCKER_REGISTRY_TOKEN not set" && exit 1)
	@echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	$(touch)

.task/mkdir-volumes:
	@mkdir -p /var/log/{nginx,varnish,dev,me}
	$(touch)
