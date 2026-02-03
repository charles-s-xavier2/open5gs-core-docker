#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EVD="${ROOT_DIR}/evidence"

mkdir -p "${EVD}/screenshots"

echo "[1] docker ps"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | tee "${EVD}/01_docker-ps.txt"

echo "[2] logs (tail)"
docker logs --tail=120 open5gs-nrf | tee "${EVD}/02_logs_nrf.txt"
docker logs --tail=120 open5gs-amf | tee "${EVD}/03_logs_amf.txt"
docker logs --tail=120 open5gs-smf | tee "${EVD}/04_logs_smf.txt"
docker logs --tail=120 open5gs-upf | tee "${EVD}/05_logs_upf.txt"

echo "[3] portas"
{
  echo "== TCP/SCTP =="
  sudo ss -tulpn | egrep "(:7777|:38412)" || true
  echo
  echo "== UDP =="
  sudo ss -uapn | egrep "(:2152|:8805)" || true
} | tee "${EVD}/06_ports_ss.txt"

echo "[4] curl SBI NRF (7777)"
curl -sS -i http://localhost:7777/ | head -n 30 | tee "${EVD}/07_http_curl_7777.txt"

echo "OK: evidências geradas em ${EVD}"
