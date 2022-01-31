CUR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

run: .task/build
	@$(CUR)/bin

build:
	@make .task/build

.task/build: .task/tidy *.go
	@docker run -v $(CUR):/app -w /app -e CGO_ENABLED=0 golang:1.17-alpine go build -o bin .
	@mkdir -p .task; touch .task/build

.task/tidy: go.mod
	@docker run -v $(CUR):/app -w /app -e CGO_ENABLED=0 golang:1.17-alpine go mod tidy
	@mkdir -p .task; touch .task/tidy

setup:
	@ln -sfnv $(CUR)/agent.service /etc/systemd/system/agent.service
	@systemctl enable agent
	@systemctl restart agent # TODO: separate 'start' and 'restart' into 'make setup' and 'make update'
