#!/usr/bin/env bash
# =============================================================================
# templates/userdata.sh.tpl – EC2 first-boot user-data (Terraform template)
# Installs Docker and prepares the server for the ecommerce platform
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================
set -euo pipefail

# ── System update ─────────────────────────────────────────────
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y

# ── Install Docker ────────────────────────────────────────────
curl -fsSL https://get.docker.com | sh
systemctl enable --now docker

# ── Install Docker Compose plugin ────────────────────────────
apt-get install -y docker-compose-plugin

# ── Create app user ───────────────────────────────────────────
if ! id appuser &>/dev/null; then
  useradd -m -s /bin/bash appuser
fi
usermod -aG docker appuser

# ── Install Node.js ${environment} tools ─────────────────────
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# ── Harden SSH ───────────────────────────────────────────────
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/'       /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

# ── Tag instance with environment ────────────────────────────
echo "ENVIRONMENT=${environment}" >> /etc/environment

echo "user-data complete – environment: ${environment}"
