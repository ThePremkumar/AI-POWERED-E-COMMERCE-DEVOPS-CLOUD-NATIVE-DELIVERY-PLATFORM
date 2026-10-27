# =============================================================================
# Dockerfile – E-Commerce Application
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================
# ── Stage 1: Builder ──────────────────────────────────────────
FROM node:20-alpine AS builder

LABEL maintainer="Cloud Native DevOps Team"
LABEL project="AI-Powered E-Commerce DevOps Platform"

WORKDIR /app

# Copy dependency manifests first for layer caching
COPY app/package*.json ./

RUN npm ci --only=production

# Copy application source
COPY app/ .

# Build the application (if using Next.js / CRA / Vite)
RUN npm run build 2>/dev/null || true

# ── Stage 2: Production image ──────────────────────────────────
FROM node:20-alpine AS production

WORKDIR /app

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy required artifacts from builder
COPY --from=builder --chown=appuser:appgroup /app/node_modules  ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/package.json  ./package.json

# Copy optional build outputs (only copy if they exist in the builder stage)
RUN --mount=type=bind,from=builder,source=/app,target=/build \
    for dir in dist .next public; do \
      [ -d "/build/$dir" ] && cp -r "/build/$dir" "./$dir" || true; \
    done && chown -R appuser:appgroup .

USER appuser

# Application port (override via docker run -e PORT=...)
ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:3000/api/health || exit 1

CMD ["node", "dist/server.js"]
