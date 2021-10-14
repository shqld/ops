FROM varnish:7.0.0-alpine

RUN apk add --update --no-cache --virtual build-vmod \
        git \
        make \
        automake \
        autoconf \
        libtool \
        python3 \
        py3-docutils \
        # required for autoconf
        autoconf-archive \
    && \
    # Install varnish-modules
    # -----------------------
    # download the top of the varnish-modules 7.0 branch
    git clone --branch 7.0 --single-branch --depth=1 \
        https://github.com/varnish/varnish-modules.git /usr/local/lib/varnish-modules && \
    cd /usr/local/lib/varnish-modules && \
    # prepare the build, build, check and install
    ./bootstrap && \
    ./configure && \
    make && \
    make check -j 4 && \
    make install \
    && \
    # Install libvmod-uuid
    # -----------------------
    # https://github.com/otto-de/libvmod-uuid/blob/ae0ca345b9974092bf139409d2852fc46886c250/README.rst#dependencies
    apk add ossp-uuid-dev --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    git clone --single-branch --depth=1 \
        https://github.com/otto-de/libvmod-uuid.git /usr/local/lib/libvmod-uuid && \
    cd /usr/local/lib/libvmod-uuid && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make check && \
    make install \
    && \
    apk del --purge build-vmod

# https://varnish-cache.org/docs/6.0/reference/varnishd.html
ENTRYPOINT ["sh", "-c", "varnishd -F -a 0.0.0.0:6081 -f /etc/varnish/default.vcl & varnishncsa -w /var/log/varnish/access.log"]
