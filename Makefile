TEMP_DIR := $(shell mktemp -d)

.PHONY: setup
setup: /usr/bin/task
	@task setup

/usr/bin/task:
	curl --location https://taskfile.dev/install.sh -o $(TEMP_DIR)/install-taskfile.sh
	sh $(TEMP_DIR)/install-taskfile.sh -d -b /usr/bin
	rm $(TEMP_DIR)/install-taskfile.sh
