FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add bind

RUN mkdir -p /var/log/named
RUN touch /var/log/named/default.log

ADD ./named.conf /etc/bind/named.conf
ADD ./named.hosts /var/bind/master/named.hosts
ADD ./named.rev /var/bind/master/named.rev
ADD ./localhost.rev /var/bind/master/localhost.rev

RUN named-checkconf
RUN named-checkzone shqld.dev /var/bind/master/named.hosts

EXPOSE 53:53/udp

CMD ["tail", "-f", "/var/log/named/default.log"]
