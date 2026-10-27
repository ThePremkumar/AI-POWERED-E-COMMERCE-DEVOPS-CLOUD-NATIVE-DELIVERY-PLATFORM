#!/usr/bin/env bash
# =============================================================================
# health-check.sh – Application and infrastructure health verifier
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================
# FIX: Removed 'set -e' — arithmetic expressions like ((var++)) return exit
# code 1 when the result is zero (falsy), which trips set -e and kills the
# script mid-check.  We use 'set -uo pipefail' and explicit error handling.
set -uo pipefail

LOG_FILE="logs/health-check.log"
mkdir -p logs

log()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO  $*" | tee -a "$LOG_FILE"; }
warn() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARN  $*" | tee -a "$LOG_FILE"; }
fail() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR $*" | tee -a "$LOG_FILE"; }

FRONTEND_URL="${FRONTEND_URL:-http://localhost:3000}"
BACKEND_URL="${BACKEND_URL:-http://localhost:5000/api/health}"
# FIX: Use plain integer arithmetic instead of (( )) to avoid exit-code issues
PASS=0
FAIL=0

check_http() {
  local name="$1"
  local url="$2"
  local expected_code="${3:-200}"       # FIX: configurable expected status code
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "000")
  if [[ "$code" == "$expected_code" ]]; then
    log "  ✔  $name → HTTP $code"
    PASS=$((PASS + 1))                  # FIX: safe arithmetic, never returns exit 1
  else
    fail "  ✘  $name → HTTP $code (expected $expected_code)"
    FAIL=$((FAIL + 1))
  fi
}

check_docker_service() {
  local service="$1"
  # FIX: Use --format to avoid false matches on partial container name overlaps
  local running
  running=$(docker ps \
    --filter "name=^${service}$" \
    --filter "status=running" \
    --format "{{.Names}}" 2>/dev/null || echo "")
  if [[ -n "$running" ]]; then
    log "  ✔  Docker service '$service' is running"
    PASS=$((PASS + 1))
  else
    fail "  ✘  Docker service '$service' is NOT running"
    FAIL=$((FAIL + 1))
  fi
}

check_port() {
  local name="$1"
  local host="${2:-localhost}"
  local port="$3"
  # FIX: Use /dev/tcp for port reachability without requiring nc/nmap
  if (echo > /dev/tcp/"$host"/"$port") 2>/dev/null; then
    log "  ✔  Port $port ($name) is reachable on $host"
    PASS=$((PASS + 1))
  else
    fail "  ✘  Port $port ($name) is NOT reachable on $host"
    FAIL=$((FAIL + 1))
  fi
}

log "============================================================"
log " Health Check Starting"
log "============================================================"

# ── HTTP endpoint checks ─────────────────────────────────────
check_http "Frontend"     "$FRONTEND_URL"
check_http "Backend API"  "$BACKEND_URL"

# ── Docker container checks ──────────────────────────────────
# (update names to match your compose service names)
for svc in ecommerce-frontend ecommerce-backend ecommerce-db; do
  check_docker_service "$svc"
done

# ── Port reachability checks ─────────────────────────────────
check_port "Prometheus" localhost 9090
check_port "Grafana"    localhost 3001
check_port "Kibana"     localhost 5601

log "============================================================"
log " Results: PASS=$PASS  FAIL=$FAIL"
log "============================================================"

if [[ "$FAIL" -gt 0 ]]; then
  fail "Health check FAILED – $FAIL check(s) did not pass"
  exit 1
fi

log "All checks passed ✔"
exit 0
