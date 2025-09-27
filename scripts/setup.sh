#!/usr/bin/env bash
# setup.sh — Smart setup script that detects environment
set -euo pipefail

detect_environment() {
    if [ -n "${JENKINS_URL:-}" ] || [ -n "${JENKINS_HOME:-}" ]; then
        echo "jenkins"
    elif [ -f /.dockerenv ] || grep -q docker /proc/self/cgroup 2>/dev/null; then
        echo "docker"
    else
        echo "local"
    fi
}

ENV=$(detect_environment)
printf "\n[setup] Detected environment: %s\n" "$ENV"

case "$ENV" in
    "jenkins")
        echo "[setup] Running Jenkins-specific setup..."
        if [ -f "$(dirname "$0")/setup-jenkins.sh" ]; then
            "$(dirname "$0")/setup-jenkins.sh"
        else
            echo "[setup] Jenkins setup script not found, running minimal setup..."
            # Minimal setup that works in Jenkins
            mkdir -p ./logs
            command -v node && command -v npm && command -v docker
        fi
        ;;
    "docker")
        echo "[setup] Running in Docker container - minimal setup..."
        mkdir -p ./logs
        ;;
    "local")
        echo "[setup] Running local development setup..."
        if [ -f "$(dirname "$0")/setup-local.sh" ]; then
            "$(dirname "$0")/setup-local.sh"
        else
            echo "[setup] Local setup script not found"
            exit 1
        fi
        ;;
    *)
        echo "[setup] Unknown environment, running minimal setup..."
        mkdir -p ./logs
        ;;
esac

echo "[setup] Setup completed successfully for $ENV environment"