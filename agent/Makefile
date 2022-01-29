run: .task/build
	@$(PWD)/bin

build:
	@make .task/build

start: build
	@systemctl start agent
restart: build
	@systemctl restart agent
stop:
	@systemctl stop agent

.task/build: .task/tidy *.go
	@docker run -v $(PWD):/app -w /app -e CGO_ENABLED=0 golang:1.17-alpine go build -o bin .
	@mkdir -p .task; touch .task/build

.task/tidy: go.mod
	@docker run -v $(PWD):/app -w /app -e CGO_ENABLED=0 golang:1.17-alpine go mod tidy
	@mkdir -p .task; touch .task/tidy
