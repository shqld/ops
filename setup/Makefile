include ../lib.mk

# https://github.com/docker/compose/releases
DOCKER_COMPOSE_VERSION := 2.2.3

setup: .task/agent .task/login-github .task/keygen .task/auth-git .task/newrelic .task/packages .task/docker .task/users .task/sshd .task/firewall .task/ipv6 .task/cert

.task/agent:
	@$(MAKE) -C $(OPS)/agent up

.task/login-github:
	@sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
	@sudo dnf install -y gh
	@-gh auth login --web --scopes admin:public_key
	$(touch)

.task/keygen: .ssh_config
    # Partially ported from https://github.com/shqld/dotfiles/blob/5ffe897064b81b3cfa25701fc8947a099cd1cd26/Makefile#L59-L64
	@mkdir -p $(HOME)/.ssh && chmod 700 $(HOME)/.ssh
	@cat .ssh_config > $(HOME)/.ssh/config
	@$(foreach val, $(shell grep IdentityFile .ssh_config | sed 's|IdentityFile ||g'), \
        test -f $(val) || ( \
            mkdir -p $(dir $(val)); ssh-keygen -b 4096 -t ed25519 -N '' -C 'shqld@$(shell hostname)' -f $(val) \
        ); \
    )
	$(touch)

.task/auth-git: .task/keygen .task/login-github
	@gh api -X POST /user/keys -F title=shqld@$(shell hostname) -F key="$(file < $(HOME)/.ssh/git@github.com/id.pub)"
	$(touch)

.task/newrelic:
	@test -v NEW_RELIC_API_KEY || (echo "NEW_RELIC_API_KEY not set" && exit 1)
	@test -v NEW_RELIC_ACCOUNT_ID || (echo "NEW_RELIC_ACCOUNT_ID not set" && exit 1)
	@curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash
	@/usr/local/bin/newrelic install -y
	@mkdir -p /etc/newrelic-infra/logging.d
	@ln -sfnv $(CUR)/newrelic/logging.yml /etc/newrelic-infra/logging.d/logging.yml
	$(touch)

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
	@docker compose version > $(NULL) || ( \
		mkdir -p ~/.docker/cli-plugins/ && \
		curl -SL "https://github.com/docker/compose/releases/download/v$(DOCKER_COMPOSE_VERSION)/docker compose-$(shell uname -s)-$(shell uname -m)" -o ~/.docker/cli-plugins/docker compose && \
		chmod +x ~/.docker/cli-plugins/docker compose && \
		docker compose version \
	)

.task/users: .task/docker
	@id -u sho > $(NULL) || useradd sho
	@grep -q 'docker:.*:sho' -q < /etc/group || usermod -a -G docker sho
	@ls -la / | grep ops | grep -q sho || chown sho -R $(OPS)
	@test -d /home/sho/.ssh || \
        (mkdir -p /home/sho/.ssh && chmod 700 /home/sho/.ssh && chown sho -R /home/sho/.ssh)
	@curl https://github.com/shqld.keys 2> $(NULL) > /home/sho/.ssh/authorized_keys
	@chmod 600 /home/sho/.ssh/authorized_keys
	@sh sho.sudoers > /etc/sudoers.d/sho
	$(touch)

.task/sshd:
	@grep -q 'Match User \*' < /etc/ssh/sshd_config || \
		cat < sshd_config >> /etc/ssh/sshd_config
	@systemctl restart sshd
	$(touch)

.task/firewall: firewall.xml
	@sed -i'.org' -e 's|AllowZoneDrifting=yes|AllowZoneDrifting=no|' /etc/firewalld/firewalld.conf 
	@systemctl enable firewalld
	@systemctl start firewalld
	@firewall-cmd --query-lockdown || \
		firewall-cmd --lockdown-on
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

.task/cert: .task/docker
	@firewall-cmd --add-port=80/tcp
	@docker compose -f $(CUR)/cert/compose.yaml up --abort-on-container-exit --exit-code-from certbot
	@firewall-cmd --remove-port=80/tcp
	$(touch)
