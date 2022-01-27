run: .task/build
	@./bin

build:
	@make .task/build

start: build
	@systemctl start agent
restart: build
	@systemctl restart agent
stop:
	@systemctl stop agent

.task/build: .task/setup .task/tidy *.go
	@docker run -v /ops/agent:/go/src/app go-workspace go build -o bin .
	@touch .task/build

.task/tidy: .task/setup go.mod
	@docker run -v /ops/agent:/go/src/app go-workspace go mod tidy
	@touch .task/tidy

.task/setup: .task/setup/image

.task/setup/image: Dockerfile
	@docker build -t go-workspace .
	@touch .task/setup/image
