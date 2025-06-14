#!/usr/bin/env bash
set -euo pipefail

log(){ echo -e "\033[1;34m[INFO]\033[0m $1"; }
err(){ echo -e "\033[1;31m[ERROR]\033[0m $1"; }

backup_configs(){
  local backup_dir=".config_backup"
  mkdir -p "$backup_dir"
  for f in .eslintrc.json .prettierrc tsconfig.json eslint.config.js; do
    if [ -f "$f" ]; then
      cp "$f" "$backup_dir/" 2>/dev/null || true
    fi
  done
  log "Configuration backed up to $backup_dir"
}

OS="$(uname -s)"
case "$OS" in
  Linux*) PM="apt"; SUDO="sudo" ;;
  Darwin*) PM="brew"; SUDO="" ;;
  CYGWIN*|MINGW*|MSYS*) PM="choco"; SUDO="" ;;
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
  elif [ "$PM" = "brew" ]; then
    $SUDO brew install node
  else
    choco install -y nodejs
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
  elif [ "$PM" = "brew" ]; then
    $SUDO brew install --cask docker
  else
    choco install -y docker-desktop
  fi
}

ensure_jq(){
  if command -v jq >/dev/null 2>&1; then
    log "jq $(jq --version) already installed"
    return
  fi
  log "Installing jq"
  if [ "$PM" = "apt" ]; then
    $SUDO apt-get update -y
    $SUDO apt-get install -y jq
  elif [ "$PM" = "brew" ]; then
    $SUDO brew install jq
  else
    choco install -y jq
  fi
}

install_vscode_extensions(){
  if ! command -v code >/dev/null 2>&1; then
    log "VS Code not detected; skipping extension installation"
    return
  fi
  local ext_file=".vscode/extensions.json"
  if [ ! -f "$ext_file" ]; then
    log "No VS Code extension recommendations found"
    return
  fi
  log "Installing VS Code extensions"
  node - <<'EOF' | while read -r ext; do
const fs = require('fs');
const path = '.vscode/extensions.json';
const data = JSON.parse(fs.readFileSync(path, 'utf8'));
for (const e of data.recommendations) console.log(e);
EOF
  do
    if code --list-extensions | grep -q "$ext"; then
      log "$ext already installed"
    else
      code --install-extension "$ext" >/dev/null || true
      log "Installed VS Code extension $ext"
    fi
  done
}

install_chrome_devtools(){
  local url="https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi"
  case "$OS" in
    Linux*) command -v xdg-open >/dev/null 2>&1 && xdg-open "$url" >/dev/null 2>&1 & ;;
    Darwin*) command -v open >/dev/null 2>&1 && open "$url" ;;
    CYGWIN*|MINGW*|MSYS*) start "$url" >/dev/null 2>&1 ;;
  esac
  log "Opened React DevTools page in browser"
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
    pnpm
    gulp-cli
    parcel-bundler
    serve
    eslint_d
    prettier-plugin-tailwindcss
    eslint-plugin-tailwindcss
    eslint-plugin-unicorn
    eslint-plugin-perfectionist
    eslint-plugin-functional
    zx
    yalc
    commitizen
    cz-conventional-changelog
    typedoc
    esbuild
    turbo
    lerna
    vercel
    netlify-cli
    create-react-app
    @angular/cli
    @vue/cli
    yo
    generator-code
    firebase-tools
    @aws-amplify/cli
    @vercel/ncc
    lint-staged
    gitmoji-cli
    ngrok
    node-inspector
    nx
    degit
    bunyan
    open-cli
    pwmetrics
    k6
    dependency-cruiser
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

health_check(){
  log "Node: $(node --version)"
  log "NPM: $(npm --version)"
  if command -v docker >/dev/null 2>&1; then
    log "Docker: $(docker --version)"
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
    express
    cors
    helmet
    axios
    bcrypt
    jsonwebtoken
    body-parser
    morgan
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
    eslint-plugin-prettier
    jest-junit
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
    lint-staged
    gitmoji-cli
    ts-jest
    @types/jest
    jest-environment-jsdom
    @testing-library/jest-dom
    @testing-library/react
    @testing-library/user-event
    supertest
    eslint-plugin-compat
    eslint-plugin-jest
    eslint-plugin-testing-library
    eslint-plugin-cypress
    eslint-plugin-react-hooks
    webpack
    webpack-cli
    ts-loader
    babel-jest
    stylelint-config-standard
    eslint-plugin-jsdoc
    eslint-plugin-unicorn
    eslint-plugin-perfectionist
    eslint-plugin-functional
    eslint-plugin-tailwindcss
    prettier-plugin-tailwindcss
    owasp-dependency-check
    puppeteer
    pwmetrics
    k6
    dependency-cruiser
  )
  log "Installing project dependencies"
  npm install --save "${deps[@]}"
  log "Installing project dev dependencies"
  npm install --save-dev "${dev_deps[@]}"
  npx husky install
}

main(){
  local start=$(date +%s)
  log "Starting setup"
  backup_configs
  ensure_jq
  install_node
  if [ ! -f package.json ]; then
    log "Initializing npm project"
    npm init -y
  fi
  install_global_packages
  install_local_packages
  install_docker
  install_vscode_extensions
  install_chrome_devtools
  run_npm_install
  perform_security_scans
  local end=$(date +%s)
  log "Setup completed in $((end-start)) seconds"
  health_check
}

main "$@"
