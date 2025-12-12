#!/bin/bash
#

set -ouex pipefail

dnf5 install -y cargo

# for caching
export HOME="/tmp/cargofakehome"
mkdir -p "$HOME"

# for binaries
export CARGO_ROOT="/usr/image-local/rust"
mkdir -p "$CARGO_ROOT"

# install dtop
cargo install --root "$CARGO_ROOT" dtop

# profile for the path
echo 'export PATH="$PATH:'"$CARGO_ROOT/bin"\" > /etc/profile.d/zz-rust-binaries.sh

# clean up
dnf5 -y remove cargo
