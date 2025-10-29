#!/bin/bash

set -ouex pipefail

alias dnf='dnf5'

#
## lazydocker and dtop
# 
dnf install -y golang

# go caches things in $HOME and /root is a symlink 
export HOME="/tmp/gofakehome"
mkdir -p "$HOME"

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
