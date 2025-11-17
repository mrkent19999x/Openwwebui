#!/usr/bin/env bash
set -e
cp .env.example .env || true
echo "Fill .env with your keys. Then run: docker compose up -d"