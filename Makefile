.PHONY: restart-nginx
restart-nginx:
	nginx -t
	systemctl restart nginx

.PHONY: setup
setup:
	set -eu
	make setup-user
	/ops/setup/scripts/install_packages
	/ops/setup/scripts/setup_docker
	/ops/setup/scripts/setup_ipv6

.PHONY: setup-user
setup-user:
	make setup-user-sho
	make setup-user-robot

.PHONY: setup-user-sho
setup-user-sho:
	./users/sho/setup

.PHONY: setup-user-robot
setup-user-robot:
	./users/robot/setup
