#!/bin/bash

set -ouex pipefail

#
## helix and some optional deps
#
dnf install -y helix nodejs-npm ShellCheck shfmt

# set helix as the default editor
echo 'export EDITOR=hx' > /etc/profile.d/zz-default-editor.sh

# Set up a directory for lsp npm packages
NPM_PATH="/usr/image-local/npm"
mkdir -p "$NPM_PATH"
cd "$NPM_PATH"

# npm caches things in $HOME and /root is a symlink 
export HOME="/tmp/npmfakehome"
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
