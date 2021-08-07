#!/bin/bash

set -eu

cd /ops

echo "Updating yum registry ..."
yum update -y

echo "Installing packages ..."
yum install -y jq zsh
