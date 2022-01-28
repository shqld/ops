OPS_ROOT := /ops
TEMP_DIR := $(shell mktemp -d)

.PHONY: setup
setup:
	@make .task/setup
	@make -C $(OPS_ROOT)/setup
	@make -C $(OPS_ROOT)/system setup
	@make -C $(OPS_ROOT)/monitoring setup
	@make -C $(OPS_ROOT)/app setup

update: /usr/bin/task
	@git-pull
	@make setup

git-pull:
	@git diff --exit-code --quiet
	@git pull --depth=10
	@git gc --aggressive --prune=all
	@du -sh .git

login-github:
	@sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
	@sudo dnf install gh
	@gh auth login --web

cert:
	@docker run -it --rm \
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

.task/setup: .task/setup/task
	@mkdir -p .task/setup

.task/setup/task:
	@curl --location https://taskfile.dev/install.sh -o $(TEMP_DIR)/install-taskfile.sh
	@sh $(TEMP_DIR)/install-taskfile.sh -d -b /usr/bin
	@rm $(TEMP_DIR)/install-taskfile.sh
