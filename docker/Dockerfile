# =============================================================================
# Dockerfile – E-Commerce Application
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================

# ── Stage 1: Builder ──────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency manifests first for layer caching
COPY app/package*.json ./

# Install dependencies (if any exist)
RUN npm install --only=production 2>/dev/null || true

# Copy application source
COPY app/ .

# Run build script (copies server.js → dist/server.js and public/ → dist/public/)
RUN npm run build 2>/dev/null || true

# ── Stage 2: Production image ──────────────────────────────────
FROM node:20-alpine AS production

WORKDIR /app

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy everything from builder (node_modules if any, dist/, public/, package.json)
COPY --from=builder --chown=appuser:appgroup /app ./

USER appuser

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:3000/api/health || exit 1

CMD ["node", "dist/server.js"]
