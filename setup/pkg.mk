setup:
	@make -f pkg.mk .task/setup

.task/setup: .task/setup/misc .task/setup/docker .task/setup/docker-compose
	@mkdir -p .task/setup

.task/setup/misc: /ops/setup/pkg-list.txt
	@xargs dnf install -y < /ops/setup/pkg-list.txt
	@mkdir -p .task/setup; touch .task/setup/misc

.task/setup/docker:
	@yum install -y yum-utils
	@yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    # https://github.com/containers/podman/issues/4791
	@yum -y remove podman
	@yum install -y docker-ce docker-ce-cli containerd.io
	@systemctl enable docker
	@systemctl start docker
	@-docker swarm init
	@mkdir -p .task/setup; touch .task/setup/docker

.task/setup/docker-compose: .task/setup/docker
	@curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/bin/docker-compose
	@chmod +x /usr/bin/docker-compose
	@mkdir -p .task/setup; touch .task/setup/docker-compose
