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
  && make -C /ops login-github
  && make -C /ops setup
"
```
