NULL := /dev/null

setup: .task/sho .task/daemon .task/app

.task/sho: ## FIXME: (deps) make -C /ops/agent build
	@id -u sho > $(NULL) || useradd sho
	@grep -q 'docker:.*:sho' -q < /etc/group || usermod -a -G docker sho
	@ls -la / | grep ops | grep -q sho || chown sho -R /ops
	@test -d /home/sho/.ssh || \
        (mkdir -p /home/sho/.ssh && chmod 700 /home/sho/.ssh && chown sho -R /home/sho/.ssh)
	@curl https://github.com/shqld.keys 2> $(NULL) > /home/sho/.ssh/authorized_keys
	@chmod 600 /home/sho/.ssh/authorized_keys
	@cat < /ops/setup/sho.sudoers > /etc/sudoers.d/sho

.task/daemon:
	@id -u daemon > $(NULL) || useradd daemon

.task/app:
	@id -u app > $(NULL) || useradd app
