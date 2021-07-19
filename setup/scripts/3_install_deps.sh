#!/bin/bash

set -eu

cd ~/setup

echo "Updating yum registry ..."
yum update -y

echo "Installing packages ..."
yum install -y jq git zsh
