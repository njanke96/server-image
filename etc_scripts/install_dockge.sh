#!/bin/bash
# This file is to be run by a sudoer of the booted system
# It is copied to /etc/post_boot.sh
# TODO: write a service to pull and start dockge as root as soon as docker.service is ready

set -oeux

# add the current user to docker
if ! groups | grep -q '\bdocker\b'; then
  echo "Adding you to the docker group, run the script again after it exits."
  sudo usermod -aG docker $(whoami)
  newgrp docker
fi

# install dockge
sudo mkdir -p /opt/stacks /opt/dockge
cd /opt/dockge

# Download the compose.yaml
sudo curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml

# Start the server
docker compose up -d
