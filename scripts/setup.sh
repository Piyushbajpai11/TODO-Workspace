#!/usr/bin/env bash
# setup.sh — idempotent environment setup for development
# Usage: sudo ./setup.sh
set -euo pipefail

# ---- Configurable vars ----
NODE_VERSION="18"
MONGO_CONTAINER_NAME="todo-mongo"
MONGO_IMAGE="mongo:6.0"

# ---- Helpers ----
log() { printf "\n[setup] %s\n" "$*"; }

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"  # ubuntu, debian, centos, fedora, etc.
  else
    echo "unknown"
  fi
}

# ---- Start ----
log "Detecting Linux distro..."
DISTRO=$(detect_distro)
log "Distro detected: $DISTRO"

# Install Node.js (only if not present)
if command_exists node && command_exists npm; then
  log "Node & npm already installed: $(node -v) $(npm -v)"
else
  log "Installing Node.js LTS (v$NODE_VERSION)..."
  if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ]; then
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash -
    sudo apt-get update
    sudo apt-get install -y nodejs build-essential
  elif [ "$DISTRO" = "centos" ] || [ "$DISTRO" = "rhel" ] || [ "$DISTRO" = "fedora" ]; then
    curl -fsSL https://rpm.nodesource.com/setup_${NODE_VERSION}.x | sudo bash -
    sudo yum install -y nodejs gcc-c++
  else
    log "Unsupported/unknown distro. Please install Node.js v$NODE_VERSION manually."
  fi
fi

# Check Docker (recommended) — if present we'll use a Mongo container
if command_exists docker; then
  log "Docker detected: $(docker --version)"
  # Ensure the mongo container is running (if not, start it)
  if docker ps --format '{{.Names}}' | grep -q "^${MONGO_CONTAINER_NAME}$"; then
    log "Mongo container '${MONGO_CONTAINER_NAME}' already running."
  else
    if docker ps -a --format '{{.Names}}' | grep -q "^${MONGO_CONTAINER_NAME}$"; then
      log "Starting existing Mongo container..."
      docker start "${MONGO_CONTAINER_NAME}"
    else
      log "Creating & starting Mongo container (${MONGO_IMAGE})..."
      docker run -d --name "${MONGO_CONTAINER_NAME}" -p 27017:27017 -v mongo_data:/data/db "${MONGO_IMAGE}"
    fi
  fi
else
  log "Docker NOT found. Attempting to install MongoDB system package (if apt available)."
  if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ]; then
    sudo apt-get update
    sudo apt-get install -y mongodb || log "mongodb install failed — please install MongoDB manually or install Docker."
  else
    log "Automatic Mongo install not supported for this distro in the script. Please install Docker or MongoDB manually."
  fi
fi

log "Creating local logs directory at ./logs"
mkdir -p ./logs
log "Setup complete. Next: npm install in backend/frontend and test the app."
