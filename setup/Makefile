setup:
	@make .task/setup

.task/setup: .task/setup/pkgs .task/setup/users .task/setup/sshd .task/setup/agent .task/setup/firewall .task/setup/ipv6 .task/setup/cert
	@mkdir -p .task/setup

.task/setup/pkgs:
	@make -f pkg.mk setup

.task/setup/users:
	@make -f users.mk setup

.task/setup/sshd:
	@grep -q 'Match User \*' < /etc/ssh/sshd_config || \
		cat < sshd_config >> /etc/ssh/sshd_config
	@systemctl restart sshd
	@mkdir -p .task/setup; touch .task/setup/sshd

.task/setup/agent: ## FIXME: (deps) make -C /ops/agent build
	@ln -sfnv /ops/agent/agent.service /etc/systemd/system/agent.service
	@systemctl enable agent
	@systemctl start agent
	@mkdir -p .task/setup; touch .task/setup/agent

.task/setup/firewall: ./firewall.txt
	@systemctl start firewalld
	@firewall-cmd --list-ports | xargs -n1 | xargs -I{} firewall-cmd --remove-port={}
	@cat ./firewall.txt | xargs -n1 | xargs -I{} firewall-cmd --add-port={}
	@mkdir -p .task/setup; touch .task/setup/firewall

.task/setup/ipv6:
  # https://manual.sakura.ad.jp/vps/network/ipv6/centos-stream-8.html
	cat /etc/sysctl.conf
	@sed -i -e "/net.ipv6.conf.all.disable_ipv6/s/1/0/" /etc/sysctl.conf
	@sed -i -e "/net.ipv6.conf.default.disable_ipv6/s/1/0/" /etc/sysctl.conf
	cat /etc/sysctl.conf
	@ip addr show ens3
	cat /etc/sysconfig/network
	cat /etc/sysconfig/network-scripts/ifcfg-ens3
	@sed -i -e "s@^#@@g" /etc/sysconfig/network
	@sed -i -e "s@^#@@g" /etc/sysconfig/network-scripts/ifcfg-ens3
	@cat /etc/sysconfig/network
	@cat /etc/sysconfig/network-scripts/ifcfg-ens3
	@mkdir -p .task/setup; touch .task/setup/ipv6

.task/setup/cert:
	@docker run -it --rm \
			--name certbot \
			-v '/etc/letsencrypt:/etc/letsencrypt' \
			certbot/certbot \
					certonly \
							--manual \
							--domain shqld.dev \
							--domain *.shqld.dev \
							--email me@shqld.dev \
							--agree-tos \
							--manual-public-ip-logging-ok \
							--preferred-challenges dns
	@mkdir -p .task/setup; touch .task/setup/cert
