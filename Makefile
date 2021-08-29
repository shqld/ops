.PHONY: setup
setup:
	make -C /ops/setup

.PHONY: update
update:
	rm -rf /ops
	git clone https://github.com/shqld/ops /ops

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
