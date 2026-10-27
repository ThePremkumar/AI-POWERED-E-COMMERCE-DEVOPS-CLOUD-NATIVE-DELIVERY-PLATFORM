#!/usr/bin/env bash
# =============================================================================
# security/scanning/scan.sh – Integrated security scanning script
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================
set -euo pipefail

LOG_FILE="logs/security-scan.log"
mkdir -p logs security/reports

log()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO  $*" | tee -a "$LOG_FILE"; }
warn() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARN  $*" | tee -a "$LOG_FILE"; }

IMAGE="${1:-docker.io/davine-ecommerce/ecommerce-app:latest}"

log "============================================================"
log " Security Scan Starting – Target: $IMAGE"
log "============================================================"

# ── 1. Dependency vulnerability scan ──────────────────────────
log "[1/4] Running npm audit (dependency scan)..."
npm audit --audit-level=high --json > security/reports/npm-audit.json 2>/dev/null || true
log "  ✔  npm audit complete → security/reports/npm-audit.json"

# ── 2. Secret detection ────────────────────────────────────────
log "[2/4] Running secret detection..."
if command -v gitleaks &>/dev/null; then
  gitleaks detect --source=. \
    --report-format=json \
    --report-path=security/reports/gitleaks-report.json \
    --exit-code=0 || true
  log "  ✔  gitleaks complete → security/reports/gitleaks-report.json"
else
  warn "  ⚠  gitleaks not installed – install from https://github.com/gitleaks/gitleaks"
fi

# ── 3. Container image scan ────────────────────────────────────
log "[3/4] Running container image scan (Trivy)..."
if command -v trivy &>/dev/null; then
  trivy image \
    --severity HIGH,CRITICAL \
    --format json \
    --output security/reports/trivy-report.json \
    "$IMAGE" || true
  log "  ✔  trivy complete → security/reports/trivy-report.json"
else
  warn "  ⚠  trivy not installed – install from https://aquasecurity.github.io/trivy"
fi

# ── 4. Linux hardening check ───────────────────────────────────
log "[4/4] Running basic hardening checks..."
{
  echo "=== Hardening Check Report ==="
  echo "Date: $(date)"
  echo ""
  echo "── UFW Status ──"
  ufw status 2>/dev/null || echo "ufw not available"
  echo ""
  echo "── Unattended-upgrades ──"
  dpkg -l unattended-upgrades 2>/dev/null | tail -1 || echo "not installed"
  echo ""
  echo "── Root SSH login ──"
  grep -i "PermitRootLogin" /etc/ssh/sshd_config 2>/dev/null || echo "not available"
  echo ""
  echo "── World-writable files in /etc ──"
  find /etc -maxdepth 2 -perm -o+w 2>/dev/null | head -20 || true
} > security/reports/hardening-check.txt
log "  ✔  Hardening check complete → security/reports/hardening-check.txt"

log "============================================================"
log " Security Scan Complete – Reports in security/reports/"
log "============================================================"
