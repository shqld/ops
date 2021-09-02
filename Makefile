.PHONY: setup
setup:
	make -C /ops/setup

.PHONY: update
update:
	rm -rf /ops
	git clone https://github.com/shqld/ops /ops

.PHONY: deploy-daemon
deploy-daemon:
	@set -eu
	@export CONTAINER_UID=$(id -u daemon)
	docker stack deploy --compose-file /ops/daemon/docker-compose.yaml daemon

.PHONY: deploy-%
deploy-%:
	make -C /ops/services "deploy-${@:deploy-%=%}"

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
