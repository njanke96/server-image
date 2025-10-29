#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

alias dnf='dnf5'

#
## clean install of docker-ce
# 
dnf -y remove cockpit-podman \
  moby-engine \
  containerd \
  runc \
  docker-cli \
  docker-buildx \
  docker-compose \
  docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-selinux \
  docker-engine-selinux \
  docker-engine

curl --output-dir "/etc/yum.repos.d" --remote-name https://download.docker.com/linux/fedora/docker-ce.repo
chmod 644 /etc/yum.repos.d/docker-ce.repo

dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker

dnf install -y bootc


#
## helix
#
dnf install -y helix nodejs-npm ShellCheck shfmt

# set helix as the default editor
echo 'export EDITOR=hx' > /etc/profile.d/zz-default-editor.sh

# Set up a directory for lsp npm packages
NPM_PATH="/usr/image-local/npm"
mkdir -p "$NPM_PATH"
cd "$NPM_PATH"

# NPM expects a $HOME for caching
export HOME="/tmp/fakehome"
mkdir -p "$HOME"

# install and link language servers
npm i yaml-language-server@next
npm i dockerfile-language-server-nodejs
npm i @microsoft/compose-language-service
npm i bash-language-server

mkdir "$NPM_PATH/bin"
ln -s "$NPM_PATH/node_modules/.bin/yaml-language-server" "$NPM_PATH/bin/"
ln -s "$NPM_PATH/node_modules/.bin/docker-langserver" "$NPM_PATH/bin/"
ln -s "$NPM_PATH/node_modules/.bin/docker-compose-langserver" "$NPM_PATH/bin/"
ln -s "$NPM_PATH/node_modules/.bin/bash-language-server" "$NPM_PATH/bin/"

# set a profile.d
echo 'export PATH="$PATH:'"$NPM_PATH/bin"\" > /etc/profile.d/zz-langserver-binaries.sh

# clean up
dnf -y remove nodejs-npm

#
## lazydocker and dtop
# 
dnf install -y golang

# Set up a GOPATH for `go install`
export GOPATH="/usr/image-local/go"
mkdir -p "$GOPATH/bin"
mkdir -p "$GOPATH/pkg"

# install lazydocker and dtop
# these are the versions supported by the packaged golang
go install github.com/jesseduffield/lazydocker@v0.24.1
go install github.com/amir20/dtop@v0.0.37

# set a profile.d for this path
echo 'export PATH="$PATH:'"$GOPATH/bin"\" > /etc/profile.d/zz-go-binaries.sh

# clean up
dnf -y remove golang

#
## sudo NOPASSWD for %wheel
#
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> '/etc/sudoers.d/wheel_nopasswd'

#
## Misc Packages
#
dnf install -y htop cronie nmap-ncat

#
## Services personal preference
# 
systemctl enable crond.service
systemctl enable bootc-fetch-apply-updates.timer
systemctl disable rpm-ostreed-automatic.timer
systemctl disable firewalld
systemctl disable coreos-container-signing-migration-motd.service
