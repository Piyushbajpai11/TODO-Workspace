#!/usr/bin/env bash
# setup-jenkins.sh — Minimal setup for Jenkins CI/CD environment
set -euo pipefail

log() { printf "\n[setup-jenkins] %s\n" "$*"; }

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

log "Starting Jenkins-specific setup..."

# Verify essential tools are available (should be pre-installed on Jenkins agent)
log "Checking required tools..."
command_exists node || { log "ERROR: Node.js not found"; exit 1; }
command_exists npm || { log "ERROR: npm not found"; exit 1; }
command_exists docker || { log "ERROR: Docker not found"; exit 1; }

log "Node.js: $(node -v)"
log "npm: $(npm -v)"
log "Docker: $(docker --version)"

# For Jenkins, we expect MongoDB to be external or in Kubernetes
log "Assuming MongoDB will be provided via Kubernetes deployment"
log "Skipping MongoDB setup in CI environment"

log "Creating logs directory..."
mkdir -p ./logs

log "Jenkins setup complete - dependencies verified"