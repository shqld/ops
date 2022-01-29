setup: .task/misc .task/docker .task/docker-compose

.task/misc: pkg-list.txt
	@xargs dnf install -y < pkg-list.txt
	@mkdir -p .task; touch .task/misc

.task/docker:
	@yum install -y yum-utils
	@yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    # https://github.com/containers/podman/issues/4791
	@yum -y remove podman
	@yum install -y docker-ce docker-ce-cli containerd.io
	@systemctl enable docker
	@systemctl start docker
	@mkdir -p .task; touch .task/docker

.task/docker-compose: .task/docker
	@curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/bin/docker-compose
	@chmod +x /usr/bin/docker-compose
	@mkdir -p .task; touch .task/docker-compose
