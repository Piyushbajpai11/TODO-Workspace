#!/usr/bin/env bash
# logrotate.sh — simple log rotation + compression
# Usage: ./logrotate.sh /path/to/logs  # defaults to ./logs
set -euo pipefail

LOG_DIR="${1:-./logs}"
MAX_SIZE_BYTES="${2:-10485760}"  # default 10 MB
KEEP_DAYS="${3:-7}"              # keep rotated logs for 7 days

mkdir -p "$LOG_DIR"

echo "[logrotate] Rotating logs in $LOG_DIR (max size ${MAX_SIZE_BYTES} bytes)..."

shopt -s nullglob
for f in "$LOG_DIR"/*.log; do
  # skip if no .log files
  if [ ! -f "$f" ]; then
    continue
  fi

  # get file size (POSIX-ish)
  if stat --version >/dev/null 2>&1; then
    SIZE=$(stat -c%s "$f")
  else
    SIZE=$(wc -c < "$f" | tr -d ' ')
  fi

  if [ "$SIZE" -ge "$MAX_SIZE_BYTES" ]; then
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    ROTATED="${f}.${TIMESTAMP}"
    echo "[logrotate] Rotating $f -> $ROTATED"
    mv "$f" "$ROTATED"
    gzip "$ROTATED"
    # create an empty fresh log file so app can continue writing
    touch "$f"
  else
    echo "[logrotate] Skipping $f (size ${SIZE} bytes)"
  fi
done

# cleanup old gz files older than KEEP_DAYS
find "$LOG_DIR" -name "*.gz" -type f -mtime +"$KEEP_DAYS" -print -delete

echo "[logrotate] Done."
