FROM centos:8

# Convert from CentOS Linux 8 to CentOS Stream 8
# https://www.centos.org/centos-stream/
RUN dnf -y swap centos-linux-repos centos-stream-repos && \
    dnf -y distro-sync && \
    dnf -y clean all
