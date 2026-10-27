#!/usr/bin/env bash
# =============================================================================
# cleanup.sh – Remove stopped containers, dangling images, unused volumes
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================
set -euo pipefail

LOG_FILE="logs/cleanup.log"
mkdir -p logs

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

log "============================================================"
log " Cleanup Starting"
log "============================================================"

log "Removing stopped containers..."
docker container prune -f | tee -a "$LOG_FILE"

log "Removing dangling images..."
docker image prune -f | tee -a "$LOG_FILE"

log "Removing unused volumes..."
docker volume prune -f | tee -a "$LOG_FILE"

log "Removing unused networks..."
docker network prune -f | tee -a "$LOG_FILE"

log "Removing old log files (>14 days)..."
find logs/ -name "*.log" -mtime +14 -delete 2>/dev/null || true

log "============================================================"
log " Cleanup Complete"
log "============================================================"
