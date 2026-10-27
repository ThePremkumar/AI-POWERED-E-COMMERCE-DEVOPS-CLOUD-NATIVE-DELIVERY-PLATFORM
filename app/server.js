const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3000;

const productsData = [
  {
    id: 1,
    name: 'Cloud-Native Kubernetes Blueprint',
    price: 49.99,
    category: 'DevOps',
    description: 'Production EKS cluster templates, ingress controllers, Helm packaging, and automated auto-scalers.',
    imageUrl: 'https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9?w=600&auto=format&fit=crop&q=80'
  },
  {
    id: 2,
    name: 'AI Real-Time Incident Analyzer',
    price: 79.99,
    category: 'Cloud & AI',
    description: 'Autonomous log stream analyzer powered by open LLM inference pipelines with auto-triage workflows.',
    imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600&auto=format&fit=crop&q=80'
  },
  {
    id: 3,
    name: 'Multi-Cloud Terraform Stack',
    price: 39.99,
    category: 'DevOps',
    description: 'Modular Infrastructure as Code modules for automated VPC, RDS, and secure remote state locking.',
    imageUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&auto=format&fit=crop&q=80'
  },
  {
    id: 4,
    name: 'Observability & Telemetry Suite',
    price: 44.99,
    category: 'OpenSource',
    description: 'Pre-configured Prometheus metrics collectors, Grafana dashboards, and unified Logstash pipelines.',
    imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&auto=format&fit=crop&q=80'
  },
  {
    id: 5,
    name: 'DevSecOps Vulnerability Scanner',
    price: 59.99,
    category: 'DevOps',
    description: 'Automated CI/CD security scanning gates with Trivy container audits and Gitleaks credential detection.',
    imageUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&auto=format&fit=crop&q=80'
  },
  {
    id: 6,
    name: 'Distributed Redis & Cache Accelerator',
    price: 34.99,
    category: 'OpenSource',
    description: 'High-throughput in-memory clustering engine with persistence replication and sub-millisecond response.',
    imageUrl: 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=600&auto=format&fit=crop&q=80'
  }
];

const server = http.createServer((req, res) => {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  // Health check endpoint (Strict requirement for Docker, K8s, Jenkins)
  if (req.url === '/api/health' || req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      status: 'UP',
      timestamp: new Date().toISOString(),
      service: 'ecommerce-app',
      version: '1.0.0',
      uptime: process.uptime()
    }));
    return;
  }

  // Products JSON API endpoint
  if (req.url === '/api/products') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      message: 'Welcome to AI-Powered E-Commerce DevOps Platform API',
      count: productsData.length,
      products: productsData
    }));
    return;
  }

  // Root frontend UI page
  if (req.url === '/' || req.url === '/index.html') {
    const htmlPath = path.join(__dirname, 'public', 'index.html');
    fs.readFile(htmlPath, 'utf8', (err, content) => {
      if (err) {
        // Fallback if public folder is not copied
        const altPath = path.join(__dirname, '..', 'public', 'index.html');
        fs.readFile(altPath, 'utf8', (altErr, altContent) => {
          if (altErr) {
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({
              message: 'Welcome to AI-Powered E-Commerce DevOps Platform API',
              products: productsData
            }));
          } else {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            res.end(altContent);
          }
        });
        return;
      }
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      res.end(content);
    });
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

