CUR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OPS := $(realpath $(CUR)/..)

DOCKER_RUN := docker run -v $(CUR):/app -w /app -e CGO_ENABLED=0 golang:1.17-alpine

run: .task/build
	@$(CUR)/bin

build:
	@make .task/build

.task/build: .task/tidy *.go
	@$(DOCKER_RUN) go build -o bin .
	@mkdir -p .task; touch .task/build

.task/tidy: go.mod
	@$(DOCKER_RUN) go mod tidy
	@mkdir -p .task; touch .task/tidy

setup: /etc/systemd/system/agent.service
	@systemctl enable agent
	@systemctl restart agent # TODO: separate 'start' and 'restart' into 'make setup' and 'make update'

/etc/systemd/system/agent.service: $(CUR)/agent.service
	@cat $(CUR)/agent.service | sed -e 's|$$(OPS)|$(OPS)|g' > /etc/systemd/system/agent.service
