<div align="center">

# 🚀 AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform

**Production-Grade DevOps & Cloud-Native Delivery Platform**

[![CI](https://github.com/ThePremkumar/AI-POWERED-E-COMMERCE-DEVOPS-CLOUD-NATIVE-DELIVERY-PLATFORM/actions/workflows/ci.yml/badge.svg)](https://github.com/ThePremkumar/AI-POWERED-E-COMMERCE-DEVOPS-CLOUD-NATIVE-DELIVERY-PLATFORM/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Docker](https://img.shields.io/badge/Docker-✔-blue)
![Kubernetes](https://img.shields.io/badge/Kubernetes-✔-326CE5)
![Jenkins](https://img.shields.io/badge/Jenkins-✔-D24939)
![Terraform](https://img.shields.io/badge/Terraform-✔-7B42BC)
![Ansible](https://img.shields.io/badge/Ansible-✔-EE0000)

> A **production-style** DevOps ecosystem built around an e-commerce application —  
> integrating source control, containers, CI/CD, IaC, Kubernetes, monitoring, logging,  
> security, cloud deployment, and AI-assisted incident analysis into a **single connected platform**.

</div>

---

## 📋 Table of Contents

- [Executive Summary](#-executive-summary)
- [Technology Stack](#-technology-stack)
- [Repository Structure](#-repository-structure)
- [Architecture Overview](#-architecture-overview)
- [Quick Start](#-quick-start)
- [Component Details](#-component-details)
  - [Linux Environment](#linux-environment)
  - [Version Control](#version-control--collaboration)
  - [Bash Automation](#bash-automation)
  - [Docker & Containerization](#docker--containerization)
  - [CI/CD with Jenkins](#cicd-with-jenkins)
  - [Infrastructure as Code (Terraform)](#infrastructure-as-code-terraform)
  - [Configuration Management (Ansible)](#configuration-management-ansible)
  - [Kubernetes Orchestration](#kubernetes-orchestration)
  - [Helm Packaging](#helm-packaging)
  - [Monitoring (Prometheus + Grafana)](#monitoring-prometheus--grafana)
  - [Centralized Logging (ELK)](#centralized-logging-elk)
  - [DevSecOps](#devsecops)
  - [AI-Assisted Incident Analysis](#ai-assisted-incident-analysis)
  - [Cloud Deployment (AWS)](#cloud-deployment-aws)
- [Deployment Strategies](#-deployment-strategies)
- [Manual Steps Required](#-manual-steps-required)
- [Environment Variables](#-environment-variables)
- [Project Deliverables](#-project-deliverables)
- [License](#-license)

---

## 🎯 Executive Summary

The **AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform** is a production-style DevOps implementation built around an existing e-commerce application.

The project's primary objective is **not** to develop the application itself, but to establish a **complete, automated, secure, observable, scalable, and repeatable software delivery ecosystem** around it.

The complete lifecycle follows:

```
Developer Commit → GitHub → Jenkins CI/CD → Docker Build → Security Scan
  → Container Registry → Helm Deploy → Kubernetes → Prometheus/Grafana
  → ELK Logging → AI Incident Analysis → Cloud (AWS)
```

---

## 🛠 Technology Stack

| Category | Technology | Role |
|----------|-----------|------|
| **Operating System** | Linux (Ubuntu 22.04) | Application & server environment |
| **Version Control** | Git | Source-code management |
| **Collaboration** | GitHub | Repository, PRs & collaboration |
| **Automation** | Bash | Operational automation |
| **Web Server** | Nginx | Reverse proxy & web serving |
| **Containerization** | Docker | Application packaging |
| **Multi-Container** | Docker Compose | Local multi-service environment |
| **CI/CD** | Jenkins | Pipeline automation |
| **CI Alternative** | GitHub Actions | Basic CI exposure |
| **Infrastructure** | Terraform | Infrastructure provisioning (AWS) |
| **Configuration** | Ansible | Server configuration automation |
| **Orchestration** | Kubernetes (EKS) | Container orchestration |
| **Packaging** | Helm | Kubernetes application packaging |
| **Networking** | NGINX Ingress | External application access |
| **Monitoring** | Prometheus | Metrics collection |
| **Visualization** | Grafana | Monitoring dashboards |
| **Logging** | ELK Stack | Centralized log management |
| **Security** | Trivy, Gitleaks, npm audit | DevSecOps controls |
| **AI** | OpenAI API | AI incident analysis |
| **Cloud** | AWS (EC2, RDS, EKS) | Cloud deployment environment |

---

## 📁 Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── ci.yml                  # GitHub Actions CI pipeline
├── app/                            # ← Place your e-commerce app here
├── bash/
│   ├── setup.sh                   # Environment bootstrap
│   ├── health-check.sh            # Application health verification
│   ├── backup.sh                  # Database & config backup
│   └── cleanup.sh                 # Docker resource cleanup
├── docker/
│   ├── Dockerfile                 # Multi-stage production image
│   ├── .dockerignore
│   ├── docker-compose.yml         # Full local stack
│   └── nginx/
│       └── nginx.conf             # Reverse proxy config
├── jenkins/
│   └── Jenkinsfile                # Declarative CI/CD pipeline
├── terraform/
│   ├── main.tf                    # Root config (VPC, EC2, RDS, EKS)
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example   # Template (copy → terraform.tfvars)
│   └── modules/                   # VPC, EC2, RDS, EKS modules
├── ansible/
│   ├── site.yml                   # Master playbook
│   ├── vars/main.yml              # Shared variables
│   └── roles/
│       ├── common/                # Base OS setup
│       ├── docker/                # Docker installation
│       ├── app_user/              # Application user
│       ├── app_deploy/            # Application deployment
│       └── monitoring_agent/     # Node Exporter installation
├── kubernetes/
│   └── manifests/
│       ├── namespace.yml
│       ├── deployment.yml         # Rolling update strategy
│       ├── service.yml
│       ├── ingress.yml
│       ├── configmap.yml
│       └── secret.yml
├── helm/
│   └── ecommerce/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/             # Helm templates
├── monitoring/
│   ├── prometheus/
│   │   └── prometheus.yml        # Scrape configuration
│   └── grafana/
│       └── dashboards/           # Dashboard provisioning
├── logging/
│   ├── elasticsearch/
│   ├── logstash/
│   │   └── logstash.conf         # Log pipeline
│   └── kibana/
├── security/
│   └── scanning/
│       └── scan.sh               # Integrated security scan
├── ai/
│   ├── incident_analyzer.py      # AI incident analysis
│   └── requirements.txt
├── docs/                          # Architecture & implementation docs
├── .env.example                   # Environment variable template
├── .gitignore
├── instructions.md                # ← Manual steps you must complete
└── README.md                      # This file
```

---

## 🏗 Architecture Overview

### High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                       Developer                              │
│                git push → GitHub                             │
└─────────────────────┬───────────────────────────────────────┘
                       │ Webhook
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    Jenkins CI/CD Pipeline                    │
│  Checkout → Dep Scan → Secret Scan → Build → Test →         │
│  Code Quality → Docker Build → Image Scan → Push → Deploy   │
└─────────────────────┬───────────────────────────────────────┘
                       │ Helm upgrade
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                  Kubernetes (AWS EKS)                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │  Pod 1   │  │  Pod 2   │  │  Pod 3   │  (Rolling Update) │
│  └──────────┘  └──────────┘  └──────────┘                  │
│         └──────────┬──────────┘                             │
│              ┌─────▼──────┐                                 │
│              │  Service   │                                  │
│              └─────┬──────┘                                 │
│              ┌─────▼──────┐                                 │
│              │  Ingress   │ ← External Traffic               │
│              └────────────┘                                 │
└─────────────────────────────────────────────────────────────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
   ┌──────────┐ ┌──────────┐ ┌──────────┐
   │Prometheus│ │  Grafana │ │   ELK    │
   │(Metrics) │ │(Dashbrd) │ │(Logging) │
   └──────────┘ └──────────┘ └──────────┘
                                   │
                                   ▼
                          ┌─────────────────┐
                          │  AI Incident    │
                          │  Analyzer       │
                          └─────────────────┘
```

### Infrastructure Architecture (AWS)

```
AWS Account
└── VPC (10.0.0.0/16)
    ├── Public Subnets  → EC2 App Server, NAT Gateway, Load Balancer
    ├── Private Subnets → RDS Database, EKS Worker Nodes
    └── Security Groups → App SG, DB SG, EKS SG
```

---

## ⚡ Quick Start

### Prerequisites

- Linux/macOS or WSL2 on Windows
- Docker Desktop installed and running
- Git

### 1. Clone the repository

```bash
git clone https://github.com/ThePremkumar/AI-POWERED-E-COMMERCE-DEVOPS-CLOUD-NATIVE-DELIVERY-PLATFORM.git
cd AI-POWERED-E-COMMERCE-DEVOPS-CLOUD-NATIVE-DELIVERY-PLATFORM
```

### 2. Configure environment

```bash
cp .env.example .env
# Edit .env and fill in your values
```

### 3. Run the local stack

```bash
cd docker/
docker compose up -d
docker compose ps
```

### 4. Verify health

```bash
bash bash/health-check.sh
```

### 5. Access services locally

| Service | URL |
|---------|-----|
| Frontend | http://localhost:3000 |
| Backend API | http://localhost:5000 |
| Nginx (proxy) | http://localhost:80 |
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3001 |
| Kibana | http://localhost:5601 |

---

## 🔧 Component Details

### Linux Environment

The platform runs on **Ubuntu 22.04 LTS**. The Linux layer provides:
- Application runtime environment
- Docker Engine host
- Jenkins server
- Monitoring agents (Node Exporter)
- SSH-based remote management
- systemd service management

Bash scripts in `bash/` automate routine operations:

```bash
bash bash/setup.sh        # Bootstrap environment
bash bash/health-check.sh # Verify application health
bash bash/backup.sh       # Backup DB + config
bash bash/cleanup.sh      # Clean Docker resources
```

---

### Version Control & Collaboration

**Branching Strategy:**

```
main          ← Production-ready code only
  └── develop ← Integration branch
        └── feature/xyz  ← Feature branches
        └── hotfix/xyz   ← Emergency fixes
```

**Pull Request Workflow:**
1. Create feature branch from `develop`
2. Make changes & commit
3. Open Pull Request → code review
4. CI checks must pass (GitHub Actions)
5. Merge to `develop` → merge to `main` for release

---

### Bash Automation

| Script | Purpose |
|--------|---------|
| `bash/setup.sh` | Install dependencies, create directory structure |
| `bash/health-check.sh` | Check HTTP endpoints and Docker services |
| `bash/backup.sh` | PostgreSQL dump + config archive with retention |
| `bash/cleanup.sh` | Prune stopped containers, dangling images, old logs |

---

### Docker & Containerization

**Multi-stage Dockerfile** (`docker/Dockerfile`):
- Stage 1 (builder): Install deps, run build
- Stage 2 (production): Copy artifacts, run as non-root user

**Docker Compose** (`docker/docker-compose.yml`) runs:

| Service | Image | Port |
|---------|-------|------|
| frontend | Custom build | 3000 |
| backend | Custom build | 5000 |
| db | postgres:15 | 5432 |
| redis | redis:7 | 6379 |
| nginx | nginx:1.25 | 80, 443 |
| prometheus | prom/prometheus | 9090 |
| grafana | grafana/grafana | 3001 |
| elasticsearch | elastic 8.12 | 9200 |
| logstash | elastic 8.12 | 5044 |
| kibana | elastic 8.12 | 5601 |

---

### CI/CD with Jenkins

The `jenkins/Jenkinsfile` defines an **11-stage declarative pipeline**:

| Stage | Description |
|-------|-------------|
| 1. Checkout | Pull source code from GitHub |
| 2. Dependency Scan | `npm audit` – flag HIGH/CRITICAL vulnerabilities |
| 3. Secret Scan | Gitleaks – detect committed secrets |
| 4. Build | Compile/bundle the application |
| 5. Test | Run unit tests, publish coverage |
| 6. Code Quality | SonarQube static analysis |
| 7. Docker Build | Build tagged Docker image |
| 8. Image Scan | Trivy – scan image for vulnerabilities |
| 9. Push Image | Push to Docker Hub (main/develop branches) |
| 10. Deploy | `helm upgrade --install` to Kubernetes |
| 11. Verify | `kubectl rollout status` + health check |

---

### Infrastructure as Code (Terraform)

Terraform provisions the entire AWS infrastructure:

```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

**Resources provisioned:**
- VPC with public/private subnets across 2 AZs
- Security Groups for app, database, and EKS
- EC2 instance for Jenkins/auxiliary workloads
- RDS PostgreSQL (private subnet)
- EKS cluster with managed node group

---

### Configuration Management (Ansible)

Ansible automates server configuration after Terraform provisions the infrastructure:

```bash
cd ansible/
ansible-playbook -i inventory/hosts site.yml
```

**Roles:**
| Role | What it does |
|------|-------------|
| `common` | Update OS, install utilities, set timezone |
| `docker` | Install Docker Engine, add user to docker group |
| `app_user` | Create non-root application user/group |
| `app_deploy` | Deploy application files and Docker Compose |
| `monitoring_agent` | Install Node Exporter for Prometheus scraping |

---

### Kubernetes Orchestration

Manifests in `kubernetes/manifests/`:

| Manifest | Purpose |
|----------|---------|
| `namespace.yml` | Isolated `ecommerce` namespace |
| `deployment.yml` | 3-replica deployment with rolling update |
| `service.yml` | ClusterIP service |
| `ingress.yml` | External access via NGINX Ingress |
| `configmap.yml` | Non-sensitive configuration |
| `secret.yml` | Sensitive configuration (base64) |

```bash
kubectl apply -f kubernetes/manifests/
kubectl get all -n ecommerce
kubectl rollout status deployment/ecommerce-app -n ecommerce
```

---

### Helm Packaging

Helm packages all Kubernetes resources into a deployable unit:

```bash
# Install
helm install ecommerce-app helm/ecommerce/ \
  --namespace ecommerce \
  --create-namespace

# Upgrade (used by Jenkins)
helm upgrade ecommerce-app helm/ecommerce/ \
  --namespace ecommerce \
  --set image.tag=<new-tag>

# Rollback
helm rollback ecommerce-app 1 --namespace ecommerce
```

---

### Monitoring (Prometheus + Grafana)

**Prometheus** scrapes metrics from:
- Application (`/metrics` endpoint)
- Node Exporter (host CPU, memory, disk)
- cAdvisor (container metrics)
- Kubernetes pod discovery

**Grafana** dashboards provide visibility into:
- Application request rate, error rate, latency
- Container CPU and memory utilization
- Pod status and restart counts
- Node health and resource utilization

Recommended Grafana dashboard IDs to import:
- `1860` – Node Exporter Full
- `893` – Docker & system monitoring
- `315` – Kubernetes cluster overview

---

### Centralized Logging (ELK)

```
Application → Logstash (TCP:5044) → Elasticsearch → Kibana
Docker logs → Filebeat/Logstash → Elasticsearch → Kibana
```

**Logstash pipeline** (`logging/logstash/logstash.conf`):
1. **Input**: TCP JSON, Beats, Syslog
2. **Filter**: JSON parsing, timestamp normalization, log-level tagging
3. **Output**: Elasticsearch index `ecommerce-logs-YYYY.MM.dd`

Access logs via **Kibana → Discover → ecommerce-logs-*** index pattern.

---

### DevSecOps

Security is integrated directly into the delivery pipeline:

| Control | Tool | Stage |
|---------|------|-------|
| Dependency vulnerabilities | `npm audit` | Jenkins Stage 2 |
| Secret detection | Gitleaks | Jenkins Stage 3 |
| Static code analysis | SonarQube | Jenkins Stage 6 |
| Container image vulnerabilities | Trivy | Jenkins Stage 8 |
| Linux hardening | Bash + manual checks | Server setup |
| Kubernetes secrets | K8s Secrets (base64) | Deployment |

Run standalone security scan:

```bash
bash security/scanning/scan.sh docker.io/davine-ecommerce/ecommerce-app:latest
```

---

### AI-Assisted Incident Analysis

The `ai/incident_analyzer.py` script uses the OpenAI API to analyze logs and return:
- **Error classification**
- **Severity** (LOW / MEDIUM / HIGH / CRITICAL)
- **Root cause candidates**
- **Investigation steps**
- **Remediation actions**

```bash
cd ai/
pip install -r requirements.txt

# Analyze a log file
python incident_analyzer.py --log-file ../logs/app.log

# Analyze live Kubernetes logs
kubectl logs deploy/ecommerce-app -n ecommerce | python incident_analyzer.py

# Analyze inline error
python incident_analyzer.py --log-text "OOMKilled: container exceeded memory limit"
```

**Example output:**
```
======================================================================
  AI INCIDENT ANALYSIS REPORT
  Source   : logs/app.log
  Generated: 2026-10-27 10:00:00
======================================================================
  🔴  SEVERITY: HIGH
  📋 Classification: Out of Memory Error
  📝 Summary: Container exceeded configured memory limits causing OOM kill
  
  Root Cause Candidates:
    1. Memory limit too low for current workload
    2. Memory leak in application code
  
  Investigation Steps:
    1. kubectl describe pod <pod-name> -n ecommerce
    2. Check memory usage trends in Grafana
    3. Review application for unbounded caches
  
  Remediation Actions:
    1. Increase memory limits in deployment.yml (currently 512Mi)
    2. Add memory profiling to identify leak source
======================================================================
```

---

### Cloud Deployment (AWS)

The platform deploys to **AWS** maintaining the same automated delivery lifecycle:

```
GitHub → Jenkins → Docker Hub → Helm → AWS EKS
                                          │
                              ┌───────────┼───────────┐
                              │           │           │
                           EKS Pods    RDS DB    ElastiCache
                              │
                         AWS ALB (Load Balancer)
                              │
                           Route 53 (DNS)
```

After `terraform apply`, Jenkins can deploy directly to EKS using the `kubeconfig-credentials` stored in Jenkins.

---

## 🚢 Deployment Strategies

### Rolling Update (Default)

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

Pods are updated one at a time with zero downtime.

### Blue-Green Deployment

```bash
# Deploy Green version alongside Blue
helm install ecommerce-green helm/ecommerce/ \
  --set image.tag=v2.0.0 --namespace ecommerce

# Switch Ingress to Green
kubectl patch ingress ecommerce-ingress -n ecommerce \
  --patch '{"spec":{"rules":[{"http":{"paths":[{"backend":{"service":{"name":"ecommerce-green"}}}]}}]}}'

# Remove Blue when stable
helm uninstall ecommerce --namespace ecommerce
```

### Canary Deployment

```bash
# Deploy Canary (10% traffic)
helm install ecommerce-canary helm/ecommerce/ \
  --set image.tag=v2.0.0 \
  --set replicaCount=1 \
  --namespace ecommerce
# Gradually increase canary replicas, monitor, then promote
```

---

## 📖 Manual Steps Required

> **Important:** Some steps cannot be automated and must be done manually.  
> See [`instructions.md`](instructions.md) for the complete step-by-step guide covering:

- Linux server provisioning and SSH hardening
- Jenkins installation, plugin configuration, and credential setup
- GitHub webhook configuration
- AWS IAM user creation and CLI setup
- Terraform state backend setup (S3 + DynamoDB)
- Ansible inventory configuration
- Kubernetes secrets with real base64 values
- Grafana dashboard import
- Kibana index pattern setup
- AI analyzer Python environment setup

---

## 🔐 Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

| Variable | Description |
|----------|-------------|
| `NODE_ENV` | Application environment (`production`) |
| `JWT_SECRET` | JWT signing secret (strong random string) |
| `DATABASE_URL` | PostgreSQL connection string |
| `REDIS_URL` | Redis connection string |
| `GRAFANA_PASSWORD` | Grafana admin password |
| `OPENAI_API_KEY` | OpenAI API key for AI analysis |
| `AWS_REGION` | AWS region |

> ⚠️ **Never commit `.env` to Git.** It is already in `.gitignore`.

---

## ✅ Project Deliverables

| Deliverable | Status | Location |
|-------------|--------|---------|
| GitHub repository | ✅ | This repository |
| Branching strategy | ✅ | `docs/` + README |
| Linux environment guide | ✅ | `instructions.md` |
| Bash automation scripts | ✅ | `bash/` |
| Dockerfile | ✅ | `docker/Dockerfile` |
| Docker Compose | ✅ | `docker/docker-compose.yml` |
| Jenkinsfile | ✅ | `jenkins/Jenkinsfile` |
| GitHub Actions CI | ✅ | `.github/workflows/ci.yml` |
| Terraform (VPC/EC2/RDS/EKS) | ✅ | `terraform/` |
| Ansible playbook & roles | ✅ | `ansible/` |
| Kubernetes manifests | ✅ | `kubernetes/manifests/` |
| Helm chart | ✅ | `helm/ecommerce/` |
| Prometheus config | ✅ | `monitoring/prometheus/` |
| Grafana dashboards | ✅ | `monitoring/grafana/` |
| ELK / Logstash config | ✅ | `logging/` |
| Security scanning | ✅ | `security/scanning/` |
| AI incident analyzer | ✅ | `ai/incident_analyzer.py` |
| Environment template | ✅ | `.env.example` |
| Manual instructions | ✅ | `instructions.md` |
| README documentation | ✅ | `README.md` |

---

## 📄 License

This project is created for the **DevOps Internship Program**.

---

<div align="center">

**Built with ❤️ by the DevOps Team**

*Linux • Git • Docker • Jenkins • Terraform • Ansible • Kubernetes • Helm • Prometheus • Grafana • ELK • DevSecOps • AI • AWS*

</div>
