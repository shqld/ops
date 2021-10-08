# https://github.com/varnish/varnish-modules/blob/master/Dockerfile
# https://github.com/varnish/varnish-modules/issues/186

FROM varnish:7.0.0-alpine

WORKDIR /varnish-modules

ARG BUILD_TOOLS=" \
    varnish-dev \
    automake \
    autoconf \
    libtool \
    python3 \
    py-docutils \
    make \
    git \
  "

RUN apk --update --no-cache add \
  $BUILD_TOOLS

RUN git clone --single-branch https://github.com/varnish/varnish-modules.git /varnish-modules

WORKDIR /varnish-modules

RUN ./bootstrap
RUN ./configure
RUN make
RUN make check -j
RUN make install
