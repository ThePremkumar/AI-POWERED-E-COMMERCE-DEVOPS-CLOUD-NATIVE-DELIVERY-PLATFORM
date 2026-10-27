#!/usr/bin/env bash
# =============================================================================
# setup.sh – Environment bootstrap script
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================
set -euo pipefail

LOG_FILE="logs/setup.log"
mkdir -p logs

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

log "============================================================"
log " Platform Setup Starting"
log "============================================================"

# ── Detect OS ────────────────────────────────────────────────
OS="$(uname -s)"
log "Detected OS: $OS"

# ── Check required binaries ──────────────────────────────────
REQUIRED_BINS=(git docker curl wget unzip)
for bin in "${REQUIRED_BINS[@]}"; do
  if command -v "$bin" &>/dev/null; then
    log "  ✔  $bin found: $(command -v $bin)"
  else
    log "  ✘  $bin NOT found – please install it and rerun."
    exit 1
  fi
done

# ── Docker daemon check ──────────────────────────────────────
if docker info &>/dev/null; then
  log "  ✔  Docker daemon is running"
else
  log "  ✘  Docker daemon is not running. Start Docker and rerun."
  exit 1
fi

# ── Create directory structure ───────────────────────────────
log "Creating project directory structure..."
DIRS=(
  "app"
  "bash"
  "docker"
  "jenkins"
  "terraform/modules"
  "ansible/roles"
  "kubernetes/manifests"
  "helm/ecommerce/templates"
  "monitoring/prometheus"
  "monitoring/grafana/dashboards"
  "logging/elasticsearch"
  "logging/logstash"
  "logging/kibana"
  "security/scanning"
  "ai"
  "docs"
  "logs"
  "backups"
)
for d in "${DIRS[@]}"; do
  mkdir -p "$d"
  log "  Created: $d"
done

# ── Copy environment template ─────────────────────────────────
if [[ ! -f ".env" ]]; then
  cp .env.example .env 2>/dev/null || true
  log "Copied .env.example → .env (fill in your values)"
fi

log "============================================================"
log " Setup Complete"
log "============================================================"
