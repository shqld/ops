FROM centos:8

# Convert from CentOS Linux 8 to CentOS Stream 8
# https://www.centos.org/centos-stream/
RUN dnf -y swap centos-linux-repos centos-stream-repos && \
    dnf -y distro-sync && \
    dnf -y clean all

RUN dnf -y install git

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# Install Varnish 7.0
# https://varnish-cache.org/docs/trunk/installation/install_source.html
# ---------------------

RUN dnf -y install 'dnf-command(config-manager)' \
    && dnf -y config-manager --set-enabled powertools \
    && dnf -y install  diffutils python3-sphinx \
    && dnf -y install epel-release \
    && dnf -y install \
        make \
        autoconf \
        automake \
        jemalloc-devel \
        libedit-devel \
        libtool \
        libunwind-devel \
        ncurses-devel \
        pcre2-devel \
        pkgconfig \
        python3-docutils \
        cpio

RUN git clone --branch 7.0 --single-branch --depth=1 https://github.com/varnishcache/varnish-cache /usr/local/lib/varnish-cache
WORKDIR /usr/local/lib/varnish-cache
RUN ./autogen.sh && \
    ./configure && \
    make && \
    # make check # takes too long
    make install

# Install varnish-modules
# -----------------------

# the epel repo contains jemalloc
RUN dnf -y install epel-release
# install our dependencies
RUN dnf -y install git make automake libtool varnish-devel
RUN varnishd -V
# download the top of the varnish-modules 7.0 branch
RUN git clone --branch 7.0 --single-branch https://github.com/varnish/varnish-modules.git /usr/local/lib/varnish-modules
# jump into the directory
WORKDIR /usr/local/lib/varnish-modules
# prepare the build, build, check and install
RUN ./bootstrap && \
    ./configure && \
    make && \
    make check -j 4 && \
    make install


# https://varnish-cache.org/docs/6.0/reference/varnishd.html
ENTRYPOINT ["varnishd", "-F", "-a", "0.0.0.0:6081", "-f", "/etc/varnish/default.vcl"]