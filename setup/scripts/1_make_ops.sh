#!/bin/bash

set -eu

groupadd ops

mkdir /ops
chown sho -R /ops
