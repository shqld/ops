OPS_ROOT := /ops
TEMP_DIR := $(shell mktemp -d)

.PHONY: setup
setup:
	@make -C $(OPS_ROOT)/setup
	@make -C $(OPS_ROOT)/system setup
	@make -C $(OPS_ROOT)/monitoring setup
	@make -C $(OPS_ROOT)/app setup

update:
	@git-pull
	@make setup

git-pull:
	git diff --exit-code --quiet
	git fetch origin main
	git reset --hard origin/main
	git gc --aggressive --prune=all
	du -sh .git

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
