TEMP_DIR := $(shell mktemp -d)

.PHONY: setup
setup: /usr/bin/task
	@task setup

/usr/bin/task:
	curl --location https://taskfile.dev/install.sh -o $(TEMP_DIR)/install-taskfile.sh
	sh $(TEMP_DIR)/install-taskfile.sh -d -b /usr/bin
	rm $(TEMP_DIR)/install-taskfile.sh

.PHONY: update
update:
	rm -rf /ops
	git clone https://github.com/shqld/ops /ops

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
