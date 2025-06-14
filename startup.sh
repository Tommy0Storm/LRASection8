#!/usr/bin/env bash
set -e

log(){ echo -e "\033[1;34m[INFO]\033[0m $1"; }
err(){ echo -e "\033[1;31m[ERROR]\033[0m $1"; }

install_node(){
    if command -v node >/dev/null 2>&1; then
        log "Node $(node --version) already installed"
        return
    fi
    case "$OSTYPE" in
        darwin*)
            if command -v brew >/dev/null 2>&1; then
                log "Installing Node with Homebrew"
                brew install node
            else
                err "Homebrew not found. Install it from https://brew.sh/"
                exit 1
            fi
            ;;
        linux*)
            if command -v apt-get >/dev/null 2>&1; then
                log "Installing Node with apt-get"
                sudo apt-get update
                sudo apt-get install -y nodejs npm
            elif command -v yum >/dev/null 2>&1; then
                log "Installing Node with yum"
                sudo yum install -y nodejs npm
            else
                err "Unsupported Linux distribution. Please install Node manually."
                exit 1
            fi
            ;;
        msys*|cygwin*|win32*)
            if command -v choco >/dev/null 2>&1; then
                log "Installing Node with Chocolatey"
                choco install -y nodejs
            else
                err "Chocolatey not found. Install it from https://chocolatey.org/"
                exit 1
            fi
            ;;
        *)
            err "Unsupported OS: $OSTYPE"
            exit 1
            ;;
    esac
}

install_global_packages(){
    PACKAGES=(gitbook-cli @docusaurus/init jest playwright cypress vitest eslint prettier husky lighthouse npm-run-all webpack-bundle-analyzer typescript snyk)
    for pkg in "${PACKAGES[@]}"; do
        if npm list -g "$pkg" >/dev/null 2>&1; then
            log "$pkg already installed"
        else
            log "Installing $pkg"
            npm install -g "$pkg"
        fi
    done
}

main(){
    log "Starting development environment setup"
    install_node
    install_global_packages
    log "Setup complete"
}

main "$@"
