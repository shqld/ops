build: setup *.go
	@docker run -v /ops/agent:/go/src/app go-workspace go build -o bin .

tidy: setup *.go
	@docker run -v /ops/agent:/go/src/app go-workspace go mod tidy

run: build 
	@./bin

setup:
	@(docker images | grep -q go-workspace) || make setup.image

setup.image:
	@docker build -t go-workspace .
