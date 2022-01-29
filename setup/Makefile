CUR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OPS := $(realpath $(CUR)/..)

setup: .task/pkgs .task/users .task/sshd .task/agent .task/firewall .task/ipv6 .task/cert

.task/pkgs:
	@make -f pkg.mk setup

.task/users:
	@make -f users.mk setup

.task/sshd:
	@grep -q 'Match User \*' < /etc/ssh/sshd_config || \
		cat < sshd_config >> /etc/ssh/sshd_config
	@systemctl restart sshd
	@mkdir -p .task; touch .task/sshd

.task/agent: ## FIXME: (deps) make -C /ops/agent build
	@ln -sfnv $(OPS)/agent/agent.service /etc/systemd/system/agent.service
	@systemctl enable agent
	@systemctl start agent
	@mkdir -p .task; touch .task/agent

.task/firewall: firewall.txt
	@systemctl start firewalld
	@firewall-cmd --list-ports | xargs -n1 | xargs -I{} firewall-cmd --remove-port={}
	@cat firewall.txt | xargs -n1 | xargs -I{} firewall-cmd --add-port={}
	@mkdir -p .task; touch .task/firewall

.task/ipv6:
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
	@mkdir -p .task; touch .task/ipv6

.task/cert:
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
	@mkdir -p .task; touch .task/cert
