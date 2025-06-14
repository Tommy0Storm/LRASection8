#!/usr/bin/env bash
set -euo pipefail

log(){ echo -e "\033[1;34m[VERIFY]\033[0m $1"; }

log "Node version: $(node --version)"
log "NPM version: $(npm --version)"
if command -v docker >/dev/null 2>&1; then
  log "Docker version: $(docker --version)"
fi
log "Running lint"
npm run lint --if-present
log "Running format check"
npm run format --if-present
log "Running tests"
npm test --if-present
log "Running security audit"
npm audit --audit-level=high || true

