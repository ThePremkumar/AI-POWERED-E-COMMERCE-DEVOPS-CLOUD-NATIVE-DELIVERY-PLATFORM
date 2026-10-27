#!/usr/bin/env bash
# =============================================================================
# backup.sh – Application and database backup
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================
set -euo pipefail

LOG_FILE="logs/backup.log"
BACKUP_DIR="backups/$(date '+%Y-%m-%d_%H-%M-%S')"
mkdir -p "$BACKUP_DIR" logs

log()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

DB_CONTAINER="${DB_CONTAINER:-db}"
DB_NAME="${DB_NAME:-ecommerce}"
DB_USER="${DB_USER:-postgres}"
RETAIN_DAYS="${RETAIN_DAYS:-7}"

log "============================================================"
log " Backup Starting → $BACKUP_DIR"
log "============================================================"

# ── Database dump ─────────────────────────────────────────────
log "Dumping database '$DB_NAME'..."
docker exec "$DB_CONTAINER" \
  pg_dump -U "$DB_USER" "$DB_NAME" \
  > "$BACKUP_DIR/db_${DB_NAME}.sql"
log "  ✔  Database dump saved"

# ── App config backup ─────────────────────────────────────────
log "Backing up configuration files..."
cp -r docker/   "$BACKUP_DIR/docker"   2>/dev/null || true
cp .env.example "$BACKUP_DIR/.env.example" 2>/dev/null || true
log "  ✔  Config files backed up"

# ── Compress ──────────────────────────────────────────────────
ARCHIVE="${BACKUP_DIR}.tar.gz"
tar -czf "$ARCHIVE" -C "$(dirname "$BACKUP_DIR")" "$(basename "$BACKUP_DIR")"
rm -rf "$BACKUP_DIR"
log "  ✔  Archive created: $ARCHIVE"

# ── Prune old backups ─────────────────────────────────────────
log "Removing backups older than ${RETAIN_DAYS} days..."
find backups/ -name "*.tar.gz" -mtime "+${RETAIN_DAYS}" -delete
log "  ✔  Old backups pruned"

log "============================================================"
log " Backup Complete: $ARCHIVE"
log "============================================================"
