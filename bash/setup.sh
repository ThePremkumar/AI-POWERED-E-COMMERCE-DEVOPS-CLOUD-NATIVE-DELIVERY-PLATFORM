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
  # FIX: quote the command -v argument to handle bins with spaces
  if command -v "$bin" &>/dev/null; then
    log "  ✔  $bin found: $(command -v "$bin")"
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
  "terraform/modules/vpc"
  "terraform/modules/ec2"
  "terraform/modules/rds"
  "terraform/modules/eks"
  "ansible/roles/common/tasks"
  "ansible/roles/docker/tasks"
  "ansible/roles/app_user/tasks"
  "ansible/roles/app_deploy/tasks"
  "ansible/roles/monitoring_agent/tasks"
  "ansible/inventory"
  "kubernetes/manifests"
  "helm/ecommerce/templates"
  "monitoring/prometheus"
  "monitoring/grafana/dashboards"
  "logging/elasticsearch"
  "logging/logstash"
  "logging/kibana"
  "security/scanning"
  "security/reports"
  "ai/reports"
  "docs"
  "logs"
  "backups"
)
for d in "${DIRS[@]}"; do
  mkdir -p "$d"
  log "  Created: $d"
done

# ── Make bash scripts executable ─────────────────────────────
# FIX: scripts lose +x on Windows checkouts; restore here
log "Setting execute permissions on bash scripts..."
for script in bash/*.sh; do
  chmod +x "$script"
  log "  chmod +x $script"
done

# ── Copy environment template ─────────────────────────────────
if [[ ! -f ".env" ]]; then
  if cp .env.example .env 2>/dev/null; then
    log "Copied .env.example → .env (fill in your values)"
  else
    log "WARNING: .env.example not found – skipping .env creation"
  fi
fi

# ── Print summary ─────────────────────────────────────────────
log "============================================================"
log " Setup Complete"
log " Next step: edit .env with your values, then run:"
log "   cd docker && docker compose up -d"
log "============================================================"
