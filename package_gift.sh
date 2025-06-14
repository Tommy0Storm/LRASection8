#!/usr/bin/env bash
set -euo pipefail

log(){ echo -e "\033[1;34m[PACKAGE]\033[0m $1"; }
err(){ echo -e "\033[1;31m[ERROR]\033[0m $1"; }

OS="$(uname -s)"
case "$OS" in
  Linux*) PM="apt"; SUDO="sudo" ;;
  Darwin*) PM="brew"; SUDO="" ;;
  CYGWIN*|MINGW*|MSYS*) PM="choco"; SUDO="" ;;
  *) err "Unsupported OS: $OS"; exit 1 ;;
esac

ensure_zip(){
  if command -v zip >/dev/null 2>&1; then
    log "zip already installed"
    return
  fi
  log "Installing zip utility"
  if [ "$PM" = "apt" ]; then
    $SUDO apt-get update -y
    $SUDO apt-get install -y zip
  elif [ "$PM" = "brew" ]; then
    $SUDO brew install zip
  else
    choco install -y zip
  fi
}

main(){
  log "Packaging offline gift"
  ensure_zip
  TMP_DIR=$(mktemp -d)
  cp schedule8-offline.html schedule8-masterpiece.html "$TMP_DIR/"
  cp lra-full.html "$TMP_DIR/"
  cp aos.css aos.js jquery.min.js lunr.min.js turn.min.js "$TMP_DIR/"
  cp README.md "$TMP_DIR/" 2>/dev/null || true
  zip -r gift-package.zip -j "$TMP_DIR"/*
  rm -r "$TMP_DIR"
  log "Created gift-package.zip"
}

main "$@"
