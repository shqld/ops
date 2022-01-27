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
	@mkdir -p .task; touch .task/build

.task/tidy: .task/setup go.mod
	@docker run -v /ops/agent:/go/src/app go-workspace go mod tidy
	@mkdir -p .task; touch .task/tidy

.task/setup: .task/setup/image
	@mkdir -p .task/setup

.task/setup/image: Dockerfile
	@docker build -t go-workspace .
	@mkdir -p .task/setup; touch .task/setup/image
