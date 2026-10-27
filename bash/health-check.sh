#!/usr/bin/env bash
# =============================================================================
# health-check.sh – Application and infrastructure health verifier
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================
set -euo pipefail

LOG_FILE="logs/health-check.log"
mkdir -p logs

log()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO  $*" | tee -a "$LOG_FILE"; }
warn() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARN  $*" | tee -a "$LOG_FILE"; }
fail() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR $*" | tee -a "$LOG_FILE"; }

FRONTEND_URL="${FRONTEND_URL:-http://localhost:3000}"
BACKEND_URL="${BACKEND_URL:-http://localhost:5000/api/health}"
PASS=0
FAIL=0

check_http() {
  local name="$1"
  local url="$2"
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" || echo "000")
  if [[ "$code" == "200" ]]; then
    log "  ✔  $name → HTTP $code"
    ((PASS++))
  else
    fail "  ✘  $name → HTTP $code (expected 200)"
    ((FAIL++))
  fi
}

check_docker_service() {
  local service="$1"
  if docker ps --filter "name=${service}" --filter "status=running" | grep -q "$service"; then
    log "  ✔  Docker service '$service' is running"
    ((PASS++))
  else
    fail "  ✘  Docker service '$service' is NOT running"
    ((FAIL++))
  fi
}

log "============================================================"
log " Health Check Starting"
log "============================================================"

# HTTP endpoints
check_http "Frontend"       "$FRONTEND_URL"
check_http "Backend API"    "$BACKEND_URL"

# Docker services (update names to match your compose service names)
for svc in frontend backend db; do
  check_docker_service "$svc"
done

log "============================================================"
log " Results: PASS=$PASS  FAIL=$FAIL"
log "============================================================"

[[ "$FAIL" -eq 0 ]] && exit 0 || exit 1
