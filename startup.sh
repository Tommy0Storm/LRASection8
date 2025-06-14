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

install_docker(){
  if command -v docker >/dev/null 2>&1; then
    log "Docker $(docker --version) already installed"
    return
  fi
  log "Installing Docker"
  if [ "$PM" = "apt" ]; then
    $SUDO apt-get update -y
    $SUDO apt-get install -y docker.io
    $SUDO systemctl enable --now docker
  else
    $SUDO brew install --cask docker
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
    mocha
    nyc
    ava
    lighthouse
    npm-run-all
    webpack-bundle-analyzer
    typescript
    snyk
    commitlint
    nodemon
    concurrently
    cross-env
    yarn
    pm2
    http-server
    live-server
    @storybook/cli
    vite
    rollup
    parcel-bundler
    serve
    eslint_d
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

run_npm_install(){
  if [ -f package-lock.json ]; then
    log "Installing dependencies with npm ci"
    npm ci
  else
    log "Installing dependencies with npm install"
    npm install
  fi
}

perform_security_scans(){
  log "Running npm audit"
  npm audit --audit-level=high || true
  if command -v snyk >/dev/null 2>&1; then
    log "Running Snyk security scan"
    snyk test || true
  fi
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
    openseadragon
    epubjs
    fullpage.js
    typed.js
    lottie-web
    dotenv
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
    ts-node
    ts-node-dev
    concurrently
    nodemon
    eslint-plugin-security
    eslint-config-prettier
    eslint-plugin-import
    eslint-plugin-node
    eslint-plugin-react
    eslint-plugin-jsx-a11y
    mocha
    chai
    nyc
    ava
    @commitlint/cli
    @commitlint/config-conventional
    htmlhint
    stylelint
    markdownlint-cli
    prettier-plugin-jsdoc
    npm-check-updates
    dotenv-cli
    eslint-config-airbnb-base
    eslint-plugin-promise
    http-server
    live-server
    @storybook/cli
    vite
    rollup
    parcel-bundler
    serve
    eslint_d
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
  install_docker
  run_npm_install
  perform_security_scans
  log "Setup complete"
}

main "$@"
