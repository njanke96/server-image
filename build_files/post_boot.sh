#!/bin/bash
# This file is to be run by a sudoer of the booted system
# It is copied to /etc/post_boot.sh

set -ouex pipefail

# install dockge
mkdir -p /opt/stacks /opt/dockge
cd /opt/dockge

# Download the compose.yaml
curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml

# Start the server
docker compose up -d

# install lazydocker + dtop
go install github.com/jesseduffield/lazydocker@latest
go install github.com/amir20/dtop@latest

# install lang servers
npm i -g yaml-language-server@next
npm install -g dockerfile-language-server-nodejs
npm install -g @microsoft/compose-language-service
npm install -g bash-language-server
cargo install taplo-cli --locked
