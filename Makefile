TEMP_DIR := $(shell mktemp -d)

.PHONY: setup
setup: /usr/bin/task
	@task setup

.PHONY: github
github:
	@sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
	@sudo dnf install gh
	@gh auth login --web

/usr/bin/task:
	curl --location https://taskfile.dev/install.sh -o $(TEMP_DIR)/install-taskfile.sh
	sh $(TEMP_DIR)/install-taskfile.sh -d -b /usr/bin
	rm $(TEMP_DIR)/install-taskfile.sh
