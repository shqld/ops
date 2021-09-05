#! /usr/sh

socat tcp6-listen:443,fork,su=nobody,reuseaddr tcp4-connect:localhost:8443 & \
socat udp6-listen:443,fork,su=nobody,reuseaddr udp4-connect:localhost:8443
