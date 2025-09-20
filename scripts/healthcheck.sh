#!/usr/bin/env bash
# healthcheck.sh — simple HTTP health check for the backend
# Usage: ./healthcheck.sh http://localhost:5000/api/todos
set -euo pipefail

URL="${1:-http://localhost:5000/api/todos}"
TIMEOUT="${2:-5}"   # seconds
EXPECTED_CODE="${3:-200}"

printf "\n[healthcheck] Checking %s (timeout %ss) ... " "$URL" "$TIMEOUT"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT" "$URL" || echo "000")

if [ "$HTTP_CODE" -eq "$EXPECTED_CODE" ]; then
  printf "OK (HTTP %s)\n" "$HTTP_CODE"
  exit 0
else
  printf "FAIL (HTTP %s) — expected %s\n" "$HTTP_CODE" "$EXPECTED_CODE"
  exit 2
fi
