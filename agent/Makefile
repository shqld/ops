include ../lib.mk

DOCKER_RUN := docker run -v $(CUR):/app -w /app -e CGO_ENABLED=0 golang:1.17-alpine

up: .task/build agent.service
	@cat $(CUR)/agent.service | sed -e 's|$$(OPS)|$(OPS)|g' \
		> /etc/systemd/system/agent.service
	@systemctl enable agent
	@systemctl restart agent

down:
	@systemctl stop agent
	@systemctl disable agent

.task/build: .task/tidy *.go
	@$(DOCKER_RUN) go build -o bin .
	$(touch)

.task/tidy: go.mod
	@$(DOCKER_RUN) go mod tidy
	$(touch)
