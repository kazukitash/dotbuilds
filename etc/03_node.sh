#!/bin/bash -xeu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_node() {
  e_newline && e_header "[Node] Installing Node..."
  e_header "[Node] Loading anyenv..."
  eval "$(anyenv init -)"
  NODE_VERSION=$(nodenv install -l | grep -v - | grep -e "^[ ]*[0-9]\+.[0-9]\+.[0-9]\+$" | tail -1)
  if nodenv versions | grep -q $(echo $NODE_VERSION); then
    e_header "[Node] Node ver.$NODE_VERSION is already installed"
  else
    e_header "[Node] Installing Node ver.$NODE_VERSION..."
    nodenv install $NODE_VERSION
    if [ $? -ne 0 ]; then
      e_error "Install Node"
      exit 1
    fi
  fi
  nodenv global $NODE_VERSION
  e_done "Install"
}

install_modules() {
  e_newline && e_header "[Node] Installing node modules..."
  npm install -g typescript
  npm cache clean --force
  e_done "Install"
}

install_node
install_modules
