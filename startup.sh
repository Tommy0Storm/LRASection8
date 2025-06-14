#!/usr/bin/env bash
set -euo pipefail

log() { echo "[startup] $1"; }

OS="$(uname -s)"

case "$OS" in
    Linux*) PM="apt"; SUDO="sudo" ;;
    Darwin*) PM="brew"; SUDO="" ;;
    *) echo "Unsupported OS: $OS" && exit 1 ;;
 esac

log "Using package manager: $PM"

# Install Node.js if not present
if ! command -v node >/dev/null 2>&1; then
    log "Installing Node.js"
    if [ "$PM" = "apt" ]; then
        $SUDO apt-get update -y
        $SUDO apt-get install -y nodejs npm
    else
        $SUDO brew install node
    fi
else
    log "Node.js already installed"
fi

# Initialize npm project if package.json does not exist
if [ ! -f package.json ]; then
    log "Initializing npm project"
    npm init -y
fi

log "Installing project dependencies"
# Libraries for interactive HTML books and encyclopedias
npm install --save turn.js animejs lunr bootstrap

# Development tools
npm install --save-dev eslint prettier husky jest @playwright/test cypress vitest lighthouse lighthouse-ci webpack-bundle-analyzer typescript

npx husky install
log "Setup complete"
