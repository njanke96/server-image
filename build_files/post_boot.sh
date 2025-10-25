#!/bin/bash
# This file is to be run by a sudoer of the booted system
# It is copied to /etc/post_boot.sh

set -oeux

export GOPATH="$HOME/.go"
mkdir -p "$GOPATH"

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

# install lazydocker
go install github.com/jesseduffield/lazydocker@v0.24.1

# install dtop 
go install github.com/amir20/dtop@v0.0.37

# install lang servers
sudo npm i -g yaml-language-server@next
sudo npm install -g dockerfile-language-server-nodejs
sudo npm install -g @microsoft/compose-language-service
sudo npm install -g bash-language-server
cargo install taplo-cli --locked

# path
echo 'PATH="$PATH:$HOME/.go/bin"' >> $HOME/.bashrc
echo 'PATH="$PATH:$HOME/.cargo/bin"' >> $HOME/.bashrc
