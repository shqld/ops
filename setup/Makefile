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

.task/firewall: firewall.txt
	@sed -i'.org' /etc/firewalld/firewalld.conf -e 's/AllowZoneDrifting=yes/AllowZoneDrifting=no/'
	@systemctl enable firewalld
	@systemctl start firewalld
	@# Reset current configurations each time (this is why making changes without '--permanent')
	@firewall-cmd --reload
	@# Drop all incoming traffic by default
	@firewall-cmd --zone=drop --change-interface=ens3
	@# Allow listed ports
	@cat firewall.txt | xargs -n1 | xargs -I{} firewall-cmd --zone=drop --add-port={}
	firewall-cmd --get-active-zones
	@firewall-cmd --state | grep -q running || (echo "Firewall not running"; exit 1)

.task/ipv6:
  # https://manual.sakura.ad.jp/vps/network/ipv6/centos-stream-8.html
	cat /etc/sysctl.conf
	@sed -i'.org' -e "/net.ipv6.conf.all.disable_ipv6/s/1/0/" /etc/sysctl.conf
	@sed -i'.org' -e "/net.ipv6.conf.default.disable_ipv6/s/1/0/" /etc/sysctl.conf
	cat /etc/sysctl.conf
	@ip addr show ens3
	cat /etc/sysconfig/network
	cat /etc/sysconfig/network-scripts/ifcfg-ens3
	@sed -i'.org' -e "s@^#@@g" /etc/sysconfig/network
	@sed -i'.org' -e "s@^#@@g" /etc/sysconfig/network-scripts/ifcfg-ens3
	@cat /etc/sysconfig/network
	@cat /etc/sysconfig/network-scripts/ifcfg-ens3
	@systemctl restart docker
	@mkdir -p .task; touch .task/ipv6

.task/cert:
    # https://stackoverflow.com/a/57565119
	@docker run -i --rm \
			--name certbot \
			-v '/var/log/letsencrypt:/var/log/letsencrypt' \
			-v '/etc/letsencrypt:/etc/letsencrypt' \
			certbot/certbot \
					certonly \
							--verbose \
							--manual \
							--domain shqld.dev \
							--domain *.shqld.dev \
							--email me@shqld.dev \
							--agree-tos \
							--manual-public-ip-logging-ok \
							--preferred-challenges dns
	@mkdir -p .task; touch .task/cert
