#!/bin/bash
# This file is to be run by a sudoer of the booted system
# It is copied to /etc/post_boot.sh
# TODO: find out how to install lazydocker/dtop system wide during the image build
# TODO: write a service to pull and start dockge as root as soon as docker.service is ready
# TODO: find out how to install the node/rust LSPs during the image build
#       (npm/cargo install do not work, but it should be possible to pull/build and add to the system path)

set -oeux

function ask_yes_no {
  local prompt="$1"
  local response

  while true; do
    # Prompt the user
    read -r -p "$prompt [y/N]: " response

    # Convert the response to lowercase and check
    case "$response" in
    [yY] | [yY][eE][sS])
      return 0 # User said Yes
      ;;
    [nN] | [nN][oO] | "")
      return 1 # User said No or pressed Enter (default)
      ;;
    *)
      echo "Invalid input. Please enter 'y' or 'n'."
      ;;
    esac
  done
}

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
if ask_yes_no "Do you want to add \$HOME/.go/bin and \$HOME/.cargo/bin to PATH via appending to \$HOME/.bashrc?"; then
  echo 'PATH="$PATH:$HOME/.go/bin"' >>$HOME/.bashrc
  echo 'PATH="$PATH:$HOME/.cargo/bin"' >>$HOME/.bashrc
fi
