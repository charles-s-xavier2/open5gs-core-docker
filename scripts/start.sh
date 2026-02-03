#!/usr/bin/env bash
set -euo pipefail

echo "[1/3] Subindo Open5GS..."
docker compose up -d

echo "[2/3] Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo "[3/3] Portas (7777/38412/2152/8805):"
sudo ss -tulpn | egrep "(:7777|:38412)" || true
sudo ss -uapn | egrep "(:2152|:8805)" || true
