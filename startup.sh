#!/usr/bin/env bash
set -euo pipefail

log(){ echo -e "\033[1;34m[INFO]\033[0m $1"; }
err(){ echo -e "\033[1;31m[ERROR]\033[0m $1"; }

OS="$(uname -s)"
case "$OS" in
  Linux*) PM="apt"; SUDO="sudo" ;;
  Darwin*) PM="brew"; SUDO="" ;;
  *) err "Unsupported OS: $OS"; exit 1 ;;
esac
log "Detected OS: $OS"

install_node(){
  if command -v node >/dev/null 2>&1; then
    log "Node $(node --version) already installed"
    return
  fi
  log "Installing Node.js"
  if [ "$PM" = "apt" ]; then
    $SUDO apt-get update -y
    $SUDO apt-get install -y nodejs npm
  else
    $SUDO brew install node
  fi
}

install_global_packages(){
  local packages=(
    gitbook-cli
    @docusaurus/init
    jest
    playwright
    cypress
    vitest
    eslint
    prettier
    husky
    lighthouse
    npm-run-all
    webpack-bundle-analyzer
    typescript
    snyk
  )
  for pkg in "${packages[@]}"; do
    if npm list -g "$pkg" >/dev/null 2>&1; then
      log "$pkg already installed"
    else
      log "Installing $pkg globally"
      npm install -g "$pkg"
    fi
  done
}

install_local_packages(){
  local deps=(
    turn.js
    animejs
    lunr
    bootstrap
    page-flip
    wowjs
    aos
    scrollmagic
    lottie-web
  )
  local dev_deps=(
    eslint
    prettier
    husky
    jest
    @playwright/test
    cypress
    vitest
    lighthouse
    lighthouse-ci
    webpack-bundle-analyzer
    typescript
  )
  log "Installing project dependencies"
  npm install --save "${deps[@]}"
  log "Installing project dev dependencies"
  npm install --save-dev "${dev_deps[@]}"
  npx husky install
}

main(){
  log "Starting setup"
  install_node
  if [ ! -f package.json ]; then
    log "Initializing npm project"
    npm init -y
  fi
  install_global_packages
  install_local_packages
  log "Setup complete"
}

main "$@"
