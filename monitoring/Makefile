CUR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OPS := $(realpath $(CUR)/..)

define touch
	@mkdir -p $(dir $@); touch $@
endef

setup: .task/newrelic .task/install-newrelic

.task/install-newrelic:
	@test -v NEW_RELIC_API_KEY || (echo "NEW_RELIC_API_KEY not set" && exit 1)
	@test -v NEW_RELIC_ACCOUNT_ID || (echo "NEW_RELIC_ACCOUNT_ID not set" && exit 1)
	@curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash
	@/usr/local/bin/newrelic install -y
	$(touch)

.task/newrelic: .task/install-newrelic
	@mkdir -p /etc/newrelic-infra/logging.d
	@ln -sfnv $(CUR)/newrelic/logging.yml /etc/newrelic-infra/logging.d/logging.yml
	$(touch)
