#!/usr/bin/env bash
set -e
echo "Backing up data..."
docker compose exec webui tar -czf /tmp/webui_backup.tar.gz /app/data
docker compose exec qdrant tar -czf /tmp/qdrant_backup.tar.gz /qdrant/storage
echo "Backup completed"