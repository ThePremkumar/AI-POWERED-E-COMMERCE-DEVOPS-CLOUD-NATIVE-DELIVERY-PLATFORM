const http = require('http');

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  if (req.url === '/api/health' || req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      status: 'UP',
      timestamp: new Date().toISOString(),
      service: 'ecommerce-app',
      version: '1.0.0'
    }));
    return;
  }

  if (req.url === '/' || req.url === '/api/products') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      message: 'Welcome to AI-Powered E-Commerce DevOps Platform API',
      products: [
        { id: 1, name: 'Cloud Native DevOps Guide', price: 29.99 },
        { id: 2, name: 'Kubernetes Mastery', price: 49.99 }
      ]
    }));
    return;
  }

  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ error: 'Not Found' }));
});

if (require.main === module) {
  server.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
  });
}

module.exports = server;
