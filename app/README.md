# app/

> **Place your e-commerce application source code in this directory.**

The application must:

1. Have a `package.json` with `start`, `build`, and `test` scripts
2. Expose a health check endpoint: `GET /api/health` → HTTP 200
3. Listen on `PORT` environment variable (default: 3000)
4. Write logs to stdout/stderr (Docker will capture them)

See [`instructions.md`](../instructions.md) Section 12 for how to add your application.
