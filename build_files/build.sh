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

# install go for lazydocker+dtop
dnf install -y golang

#
## helix
#
dnf install -y helix

# npm and cargo for LSP installation
dnf install -y nodejs-npm cargo

# bash langserver utilities
dnf install -y ShellCheck shfmt

# set helix as the default editor
echo 'export EDITOR=hx' > /etc/profile.d/zz-default-editor.sh

#
## sudo NOPASSWD for %wheel
#
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> '/etc/sudoers.d/wheel_nopasswd'

#
## Disable motd warning
#
systemctl disable coreos-container-signing-migration-motd.service

#
## Misc Packages
#
dnf install -y htop cronie

systemctl enable crond.service
