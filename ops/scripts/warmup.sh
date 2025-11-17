#!/usr/bin/env bash
set -e
echo "Warming profiles..."
curl -s -X POST http://localhost:8080/v1/chat/completions -H "Content-Type: application/json" \
  -d '{"model":"auto","messages":[{"role":"user","content":"Xin chào"}]}' >/dev/null || true