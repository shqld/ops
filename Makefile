include setup/Makefile
include app/Makefile
include system/Makefile

.PHONY: setup
setup:
	sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
	/usr/local/bin/task -d /ops setup

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
	@touch $(BEE)/$(@)
