# 📸 Project Documentation & Live Verification Evidence

This document provides visual proof and operational verification for the **AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform** developed during the **Davine Technologies Internship**.

All screenshots in this document represent live execution within the production-equivalent environment:
* **CI/CD Automation:** Jenkins Declarative Pipeline (Build #22 / #23)
* **Container Registry:** Docker Hub (`thepremkumar/ecommerce-app`)
* **Container Orchestration:** Kubernetes (KinD cluster: `kind-k8s`)
* **Microservices:** Node.js NexusOps E-Commerce Application
* **Telemetry & Monitoring:** Prometheus Operator & Grafana

---

## 📑 Table of Visual Evidence

| Section | Category | Evidence Focus |
|---|---|---|
| [1. CI/CD Pipeline Automation](#1-cicd-pipeline-automation-jenkins) | Jenkins Automation | End-to-end 8-stage pipeline execution & Docker build/push logs |
| [2. Container Artifact Registry](#2-container-artifact-registry-docker-hub) | Docker Hub | Public/private image publishing, tagging (`:latest`, `:build#`), immutability |
| [3. Kubernetes Orchestration](#3-kubernetes-orchestration--cluster-state) | Kubernetes Workloads | Active running pods, ClusterIP services, replica sets in `ecommerce` namespace |
| [4. Application Frontend & APIs](#4-live-application-frontend--microservice-apis) | Web App & APIs | Live NexusOps web store UI, JSON catalog API, health check, `/metrics` |
| [5. Telemetry & Observability](#5-telemetry--observability-prometheus--grafana) | Monitoring Stack | Prometheus active target health (UP), Grafana SRE & cluster dashboards |

---

## 1. CI/CD Pipeline Automation (Jenkins)

### Figure 1: Jenkins Full Pipeline — All 8 Stages Green Execution
* **URL:** `http://localhost:8080/job/Full%20Pipeline/`
* **Description:** Demonstrates complete end-to-end automation across all 8 pipeline stages: **Checkout SCM ➔ Checkout ➔ Build & Test ➔ Docker Build ➔ Docker Push ➔ Deploy to Kubernetes ➔ Verify Rollout ➔ Post Actions**. Execution time is under 60 seconds with 100% pass rate.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113047.png" alt="Jenkins Full Pipeline All Stages Green" width="900"/>
</p>

---

### Figure 2: Jenkins Stage Detail — Docker Push & Registry Authentication Logs
* **URL:** `http://localhost:8080/job/Full%20Pipeline/stages/`
* **Description:** Console logs demonstrating secure credential injection via Jenkins `withCredentials`, non-interactive authentication over stdin, layer-by-layer push to Docker Hub, and cryptographic digest verification (`sha256:...`).

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113141.png" alt="Jenkins Docker Push Logs" width="900"/>
</p>

---

## 2. Container Artifact Registry (Docker Hub)

### Figure 3: Docker Hub Repository Tags (`thepremkumar/ecommerce-app`)
* **URL:** `https://hub.docker.com/r/thepremkumar/ecommerce-app/tags`
* **Description:** Verifies published immutable container image tags (`:latest`, `:20`, `:19`, `:18`, `:17`) with compressed image size (~48.37 MB), demonstrating reliable artifact traceability and rollback readiness.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20105904.png" alt="Docker Hub Repository Tags" width="900"/>
</p>

---

### Figure 4: Docker Hub Repository Architecture & Overview
* **URL:** `https://hub.docker.com/r/thepremkumar/ecommerce-app`
* **Description:** Illustrates the verified repository namespace structure adhering to Docker Hub's two-segment `<namespace>/<repository>` convention.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20101454.png" alt="Docker Hub Repository Overview" width="900"/>
</p>

---

## 3. Kubernetes Orchestration & Cluster State

### Figure 5: Kubernetes Workload State in `ecommerce` Namespace
* **Command:** `kubectl --context kind-k8s get all -n ecommerce`
* **Description:** Confirms active Kubernetes cluster state:
  * **Pods:** 3 healthy replicas (`ecommerce-app-7d444d8d94-*`) in `Running` state.
  * **Service:** `ecommerce-app` ClusterIP mapping port 80 to targetPort 3000.
  * **Deployment:** `ecommerce-app` reporting 3/3 ready, up-to-date, and available replicas.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113200.png" alt="Kubernetes Pods and Service Status" width="800"/>
</p>

---

## 4. Live Application Frontend & Microservice APIs

### Figure 6: NexusOps E-Commerce Web Application Live Frontend UI
* **URL:** `http://localhost:8888/`
* **Description:** The responsive modern web storefront for the cloud-native e-commerce application running inside Kubernetes, serving dynamic catalog cards, real-time pricing, and feature highlights.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113408.png" alt="NexusOps Web Application Frontend" width="900"/>
</p>

---

### Figure 7: Microservice Catalog REST API Endpoint
* **URL:** `http://localhost:8888/api/products`
* **Description:** Backend REST API returning structured JSON product data (IDs, names, prices, categories, descriptions, and image links).

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113831.png" alt="Catalog REST API Endpoint" width="900"/>
</p>

---

### Figure 8: Microservice Liveness & Health Verification API
* **URL:** `http://localhost:8888/api/health`
* **Description:** Returns HTTP 200 with status `"UP"`, service identifier, version `1.0.0`, timestamp, and live uptime. Utilized by Kubernetes liveness and readiness probes to guarantee self-healing and zero downtime.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113809.png" alt="Microservice Health API Endpoint" width="900"/>
</p>

---

### Figure 9: Native Prometheus Metrics Exporter Endpoint
* **URL:** `http://localhost:8888/metrics`
* **Description:** Native OpenMetrics/Prometheus compliant telemetry stream exported directly from the Node.js application, reporting process uptime, resident memory bytes (RSS), heap memory consumption, CPU user/system counters, and HTTP request statistics.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113841.png" alt="Prometheus Metrics API Endpoint" width="900"/>
</p>

---

## 5. Telemetry & Observability (Prometheus & Grafana)

### Figure 10: Prometheus Target Health Console (`serviceMonitor/ecommerce/ecommerce-app`)
* **URL:** `http://localhost:9090/targets`
* **Description:** Proves that the Kubernetes Prometheus Operator dynamically discovered the `ecommerce-app` pods via the declarative `ServiceMonitor`. All 3 pod endpoints (`10.244.0.14:3000`, `10.244.0.15:3000`, `10.244.0.16:3000`) report active scraping state **UP (green)**.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113219.png" alt="Prometheus ServiceMonitor Targets UP" width="900"/>
</p>

---

### Figure 11: Prometheus Scrape Targets Overview
* **URL:** `http://localhost:9090/targets`
* **Description:** Demonstrates cluster-wide scrape pool health, confirming metrics collection across node exporters, kube-state-metrics, and microservice workloads.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20111234.png" alt="Prometheus Cluster Scrape Pools" width="900"/>
</p>

---

### Figure 12: Grafana SRE Dashboard — Ecommerce App CI/CD Overview
* **URL:** `http://localhost:3000/d/ecommerce-app/ecommerce-app-ci-cd-overview`
* **Description:** Custom-engineered SRE dashboard displaying 8 real-time operational panels:
  * **Pod CPU Usage:** Multi-pod timeseries graph
  * **Pod Memory Usage:** Resident working set bytes
  * **Running Pods:** Current active healthy pods (3)
  * **Deployment Replicas Available:** Target replica readiness (3)
  * **Container Restarts:** Fault detection counter (0)
  * **Network Receive / Transmit:** Bandwidth utilization in bytes/second

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113316.png" alt="Grafana Ecommerce Application Dashboard" width="900"/>
</p>

---

### Figure 13: Grafana Cluster Dashboard — Kubernetes Compute Resources (Pods)
* **URL:** `http://localhost:3000/d/85a562078cdf77779eaa1add43ccec1e/kubernetes-compute-resources-namespace-pods`
* **Description:** Deep infrastructure telemetry showing CPU core allocation, memory quotas, and network packet throughput across all microservice pods filtered to the `ecommerce` namespace.

<p align="center">
  <img src="../images/Screenshot%202026-10-29%20113326.png" alt="Grafana Kubernetes Pods Compute Dashboard" width="900"/>
</p>

---

## 🛠️ Verification & Access Reference Table

| Service / Component | Port | Local URL | Credentials / Notes |
|---|---|---|---|
| **Jenkins Automation** | `8080` | [http://localhost:8080](http://localhost:8080) | Pre-authenticated pipeline manager |
| **NexusOps Web App** | `8888` | [http://localhost:8888](http://localhost:8888) | Forwarded from `svc/ecommerce-app:80` |
| **Catalog API** | `8888` | [http://localhost:8888/api/products](http://localhost:8888/api/products) | Returns JSON product catalog |
| **Health API** | `8888` | [http://localhost:8888/api/health](http://localhost:8888/api/health) | Returns JSON `{ "status": "UP" }` |
| **App Metrics** | `8888` | [http://localhost:8888/metrics](http://localhost:8888/metrics) | OpenMetrics format telemetry stream |
| **Prometheus Console** | `9090` | [http://localhost:9090](http://localhost:9090) | Targets & PromQL time-series browser |
| **Grafana Dashboards** | `3000` | [http://localhost:3000](http://localhost:3000) | User: `admin` / Password: `j3RYLQOfgxyQkQTtXJuPsyfVt2nwCVkVw4WDvhkd` |
| **Docker Hub Registry** | Cloud | [thepremkumar/ecommerce-app](https://hub.docker.com/r/thepremkumar/ecommerce-app) | Published container tags `:latest`, `:20`, `:21`, `:22` |
