#!/bin/bash
while true; do
  echo "=== $(date) ===" >> ~/annas_recent.log
  curl -s https://annas-archive.org/dyn/recent_downloads/ | jq -c '.' >> ~/annas_recent.log
  sleep 60  # 5 minutes
done
