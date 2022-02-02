CUR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OPS := $(realpath $(CUR)/..)

define touch
	@mkdir -p $(dir $@); touch $@
endef

setup: .task/packages .task/users .task/sshd .task/agent .task/firewall .task/ipv6 .task/cert

.task/packages: pkg-list.txt
	@cat pkg-list.txt | grep 'add-repo ' | sed 's|add-repo ||' | \
        xargs -n1 -I{} dnf config-manager --add-repo={}
	@cat pkg-list.txt | grep 'rm ' | sed 's|rm ||' | \
        xargs dnf remove -y
	@cat pkg-list.txt | grep 'add ' | sed 's|add ||' | \
        xargs dnf install -y
	$(touch)

.task/docker: .task/packages
	@systemctl enable docker
	@systemctl start docker
	@which docker-compose || ( \
		curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/bin/docker-compose && \
		chmod +x /usr/bin/docker-compose \
	)
	$(touch)

.task/users:
	@make -f users.mk setup

.task/sshd:
	@grep -q 'Match User \*' < /etc/ssh/sshd_config || \
		cat < sshd_config >> /etc/ssh/sshd_config
	@systemctl restart sshd
	$(touch)

.task/firewall: firewall.xml
	@sed -i'.org' -e 's|AllowZoneDrifting=yes|AllowZoneDrifting=no|' /etc/firewalld/firewalld.conf 
	@systemctl enable firewalld
	@systemctl start firewalld
	@(firewall-cmd --get-zones | grep -vq shqld) || \
		firewall-cmd --permanent --delete-zone=shqld
	@firewall-cmd --permanent --name=shqld --new-zone-from-file=$(CUR)/firewall.xml
	@(firewall-cmd --get-default-zone | grep -q shqld) || \
		firewall-cmd --set-default-zone=shqld
	@firewall-cmd --query-interface=ens3 || \
		firewall-cmd --permanent --change-interface=ens3
	@firewall-cmd --reload
	@firewall-cmd --state | grep -q running || (echo "Firewall not running"; exit 1)
	$(touch)

.task/ipv6:
  # https://manual.sakura.ad.jp/vps/network/ipv6/centos-stream-8.html
	cat /etc/sysctl.conf
	@sed -i'.org' -e "|net.ipv6.conf.all.disable_ipv6|s|1|0|" /etc/sysctl.conf
	@sed -i'.org' -e "|net.ipv6.conf.default.disable_ipv6|s|1|0|" /etc/sysctl.conf
	cat /etc/sysctl.conf
	@ip addr show ens3
	cat /etc/sysconfig/network
	cat /etc/sysconfig/network-scripts/ifcfg-ens3
	@sed -i'.org' -e "s|^#||g" /etc/sysconfig/network
	@sed -i'.org' -e "s|^#||g" /etc/sysconfig/network-scripts/ifcfg-ens3
	@cat /etc/sysconfig/network
	@cat /etc/sysconfig/network-scripts/ifcfg-ens3
	@systemctl restart docker
	$(touch)

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
	$(touch)
