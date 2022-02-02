## Prerequisites

```sh
$ cat /etc/os-release

NAME="CentOS Stream"
VERSION="8"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="8"
PLATFORM_ID="platform:el8"
PRETTY_NAME="CentOS Stream 8"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:8"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 8"
REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"
```

## Initialization

```sh
ssh root@shqld.dev "
  yum install -y git \
  && rm -rf /ops \
  && git clone https://github.com/shqld/ops.git /ops \
  && make -C /ops .task/login-github \
  && make -C /ops setup \
"
```

## Roadmaps

-   [x] remove (users) app / daemon
-   [ ] add user: app for running applications in docker
-   [ ] check firewalld correctly works
-   [ ] get docker registry token by API
-   [ ] add .gitconfig for ssh connection
-   [x] move login-github to setup/Makefile
-   [ ] update docker container image by agent
-   [ ] issue certs by http-challenge01
-   [ ] make parallel
-   [x] run 'make \*' command from agent, instead of directly calling commands
-   [ ] unify all makefiles
-   [x] define function/macro for "mkdir -p .task; touch"
-   [x] enable firewalld lockdown
-   [ ] Include some .conf files from /etc/ssh/sshd_config
-   [ ] git stash when remote's workspace is dirty
