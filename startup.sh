#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[startup] $1"
}

OS_TYPE="$(uname -s)"
log "Detected OS: $OS_TYPE"

install_node_linux() {
  if ! command -v node >/dev/null 2>&1; then
    log "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
  else
    log "Node.js already installed"
  fi
}

install_node_mac() {
  if ! command -v brew >/dev/null 2>&1; then
    log "Homebrew not found. Please install Homebrew first." && return
  fi
  if ! command -v node >/dev/null 2>&1; then
    log "Installing Node.js via Homebrew..."
    brew install node
  else
    log "Node.js already installed"
  fi
}

case "$OS_TYPE" in
  Linux*) install_node_linux ;;
  Darwin*) install_node_mac ;;
  *) log "Windows users should install Node.js manually." ;;
esac

log "Installing global npm packages"
npm install -g eslint prettier typescript || log "npm global install failed"

if [ -f package.json ]; then
  log "Installing project dependencies"
  npm install || log "npm install failed"
fi

log "Setup complete"
