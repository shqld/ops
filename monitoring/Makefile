OPS_ROOT := /ops

setup: .task/newrelic .task/install-newrelic

.task/install-newrelic:
	@test -v NEW_RELIC_API_KEY || (echo "NEW_RELIC_API_KEY not set" && exit 1)
	@test -v NEW_RELIC_ACCOUNT_ID || (echo "NEW_RELIC_ACCOUNT_ID not set" && exit 1)
	@curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash
	@/usr/local/bin/newrelic install -y
	@mkdir -p .task; touch .task/install-newrelic

.task/newrelic: .task/install-newrelic
	@mkdir -p /etc/newrelic-infra/logging.d
	@ln -sfnv $(OPS_ROOT)/monitoring/newrelic/logging.yml /etc/newrelic-infra/logging.d/logging.yml
	@mkdir -p .task; touch .task/newrelic
