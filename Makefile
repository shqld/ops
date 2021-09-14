DOCKER_CONFIG_PATH = "$HOME/.docker/config.json"

.PHONY: setup
setup:
	make -C /ops/setup

.PHONY: update
update:
	rm -rf /ops
	git clone https://github.com/shqld/ops /ops

.PHONY: app-%
app-%:
	make -C /ops/app "${@:app-%=%}"

.PHONY: update-gateway
update-gateway:
	@set -eu
	@grep 'ghcr.io' < $(DOCKER_CONFIG_PATH) || \
		echo "${DOCKER_REGISTRY_TOKEN}" | docker login -u shqld --password-stdin ghcr.io
	@export CONTAINER_UID=$(id -u app)
	docker-compose -f /ops/gateway/docker-compose.yaml pull
	docker stack up gateway --compose-file /ops/gateway/docker-compose.yaml --prune

.PHONY: issue-cert
issue-cert:
	docker run -it --rm \
		--name certbot \
		-v '/etc/letsencrypt:/etc/letsencrypt' \
		certbot/certbot \
			certonly \
				--manual \
				--domain shqld.dev \
				--email me@shqld.dev \
				--agree-tos \
				--manual-public-ip-logging-ok \
				--preferred-challenges dns

.PHONY: help
MAKEOVERRIDES =
help:
	@printf "%-20s %s\n" "Target" "Description"
	@printf "%-20s %s\n" "------" "-----------"
	@make -pqR : 2>/dev/null \
		| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
		| sort \
		| egrep -v -e '^[^[:alnum:]]' -e '^$@$$' \
		| xargs -I _ sh -c 'printf "%-20s " _; make _ -nB | (grep -i "^# Help:" || echo "") | tail -1 | sed "s/^# Help: //g"'
