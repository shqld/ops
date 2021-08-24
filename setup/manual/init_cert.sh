#! /bin/bash

certbot certonly \
  --manual \
  --domain shqld.dev \
  --email me@shqld.dev \
  --agree-tos \
  --manual-public-ip-logging-ok \
  --preferred-challenges dns
