#!/usr/bin/env bash
set -e
echo "Checking containers..."
docker compose ps
echo "Ping models-gateway..."
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8080/v1/chat/completions || true
echo "Done."