# Instructions – Manual Steps Required

> **What this file is for:** Everything in this repository that **cannot be automated** must be done manually.  
> Work through each section **in order** before running automated pipelines.

---

## Section 1 – Linux Server Preparation

### 1.1 – Provision a Linux Server

You need an **Ubuntu 22.04 LTS** server (VM, cloud, or bare-metal) with:

- Minimum **2 vCPU / 4 GB RAM / 20 GB disk** for development
- Minimum **4 vCPU / 8 GB RAM / 50 GB disk** for production
- A **public IP address** (or VPN-accessible IP)
- **Port 22 (SSH)** open in the firewall

```bash
# After getting the server, update it
sudo apt update && sudo apt upgrade -y
```

### 1.2 – Create a Non-Root User

```bash
sudo adduser devopsuser
sudo usermod -aG sudo devopsuser
su - devopsuser
```

### 1.3 – Set Up SSH Key Authentication

On your **local machine**:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
ssh-copy-id devopsuser@YOUR_SERVER_IP
```

Disable password SSH login on the server:

```bash
sudo nano /etc/ssh/sshd_config
# Set:  PasswordAuthentication no
#       PermitRootLogin no
sudo systemctl restart sshd
```

---

## Section 2 – Docker Installation (if not using Ansible)

> **Skip this section** if you run the Ansible playbook — it installs Docker automatically.

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
newgrp docker
docker --version
```

---

## Section 3 – Jenkins Setup

### 3.1 – Install Jenkins on the server

```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins
sudo systemctl enable --now jenkins
```

### 3.2 – Unlock Jenkins

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

1. Open `http://YOUR_SERVER_IP:8080` in your browser
2. Paste the initial admin password
3. Install **Suggested Plugins**
4. Create your admin account

### 3.3 – Install Additional Jenkins Plugins (manually in UI)

Navigate to **Manage Jenkins → Plugins → Available** and install:

| Plugin | Purpose |
|--------|---------|
| Docker Pipeline | Docker build/push in pipeline |
| Kubernetes CLI | `kubectl` commands in pipeline |
| GitHub Integration | Webhook triggers |
| HTML Publisher | Publish test/scan reports |
| Credentials Binding | Safe secret injection |
| Blue Ocean | Modern pipeline UI (optional) |

### 3.4 – Configure Jenkins Credentials

Navigate to **Manage Jenkins → Credentials → System → Global**:

| ID | Type | Value |
|----|------|-------|
| `dockerhub-creds` | Username/Password | Your Docker Hub login |
| `kubeconfig-credentials` | Secret File | Your `~/.kube/config` |
| `sonar-token` | Secret Text | SonarQube token |
| `github-token` | Secret Text | GitHub personal access token |

### 3.5 – Create the Pipeline Job

1. **New Item → Pipeline**
2. Name it `ecommerce-pipeline`
3. Under **Pipeline**:
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: `https://github.com/ThePremkumar/AI-POWERED-E-COMMERCE-DEVOPS-CLOUD-NATIVE-DELIVERY-PLATFORM.git`
   - Script Path: `jenkins/Jenkinsfile`
4. Enable **GitHub hook trigger for GITScm polling**
5. Click **Save**

### 3.6 – Configure GitHub Webhook

1. Go to your GitHub repo → **Settings → Webhooks → Add webhook**
2. Payload URL: `http://YOUR_SERVER_IP:8080/github-webhook/`
3. Content type: `application/json`
4. Events: **Just the push event**
5. Click **Add webhook**

---

## Section 4 – AWS Account Setup (Cloud Deployment)

### 4.1 – Create AWS Account

Sign up at [https://aws.amazon.com](https://aws.amazon.com) if you don't have an account.

### 4.2 – Create IAM User for Terraform

1. AWS Console → **IAM → Users → Create user**
2. Name: `terraform-devops`
3. Attach policies:
   - `AmazonEC2FullAccess`
   - `AmazonRDSFullAccess`
   - `AmazonEKSClusterPolicy`
   - `AmazonVPCFullAccess`
   - `IAMFullAccess`
4. Create **Access Key** (type: CLI)
5. Save the **Access Key ID** and **Secret Access Key**

### 4.3 – Configure AWS CLI

```bash
pip install awscli
aws configure
# Enter: Access Key ID, Secret Access Key, Region (us-east-1), Output (json)
aws sts get-caller-identity   # verify it works
```

### 4.4 – Create EC2 Key Pair

```bash
aws ec2 create-key-pair \
  --key-name my-key-pair \
  --query "KeyMaterial" \
  --output text > ~/.ssh/my-key-pair.pem
chmod 400 ~/.ssh/my-key-pair.pem
```

### 4.5 – Create S3 Bucket for Terraform State (optional but recommended)

```bash
aws s3api create-bucket \
  --bucket davine-terraform-state \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket davine-terraform-state \
  --versioning-configuration Status=Enabled

aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

---

## Section 5 – Terraform Execution

### 5.1 – Fill in Variables

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
nano terraform/terraform.tfvars
# Fill in: key_name, db_username, db_password, aws_region
```

### 5.2 – Run Terraform

```bash
cd terraform/
terraform init
terraform plan -out=plan.out
terraform apply plan.out
# Note the outputs: app_server_public_ip, eks_cluster_name
```

---

## Section 6 – Ansible Configuration

### 6.1 – Set Up the Inventory File

```bash
# Create the inventory file (not committed to Git)
cat > ansible/inventory/hosts << EOF
[app_servers]
YOUR_SERVER_IP ansible_user=devopsuser ansible_ssh_private_key_file=~/.ssh/my-key-pair.pem

[db_servers]
YOUR_DB_IP ansible_user=devopsuser ansible_ssh_private_key_file=~/.ssh/my-key-pair.pem
EOF
```

### 6.2 – Run the Ansible Playbook

```bash
cd ansible/
ansible-playbook -i inventory/hosts site.yml --check   # dry-run first
ansible-playbook -i inventory/hosts site.yml           # apply
```

---

## Section 7 – Kubernetes / EKS Setup

### 7.1 – Configure kubectl

```bash
aws eks --region us-east-1 update-kubeconfig \
  --name dev-ecommerce-cluster
kubectl get nodes   # verify cluster access
```

### 7.2 – Install NGINX Ingress Controller

```bash
kubectl apply -f \
  https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/aws/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

### 7.3 – Apply Kubernetes Manifests

```bash
kubectl apply -f kubernetes/manifests/namespace.yml
kubectl apply -f kubernetes/manifests/configmap.yml
# Edit secret values first!
kubectl apply -f kubernetes/manifests/secret.yml
kubectl apply -f kubernetes/manifests/deployment.yml
kubectl apply -f kubernetes/manifests/service.yml
kubectl apply -f kubernetes/manifests/ingress.yml
kubectl get all -n ecommerce
```

---

## Section 8 – Secrets Management

### 8.1 – Replace Placeholder Secrets

Before applying `secret.yml`, generate real base64 values:

```bash
echo -n "postgresql://user:password@db:5432/ecommerce" | base64
echo -n "your-strong-jwt-secret" | base64
echo -n "redis://redis:6379" | base64
```

Replace the placeholders in `kubernetes/manifests/secret.yml`, then:

```bash
kubectl apply -f kubernetes/manifests/secret.yml
```

---

## Section 9 – Monitoring Setup

### 9.1 – Access Grafana

1. Open `http://YOUR_SERVER_IP:3001` (or via port-forward: `kubectl port-forward svc/grafana 3001:3000 -n monitoring`)
2. Login with `admin` / your Grafana password from `.env`
3. **Add Prometheus data source**: URL = `http://prometheus:9090`
4. Import dashboards:
   - **Node Exporter Full**: ID `1860`
   - **Docker monitoring**: ID `893`
   - **Kubernetes cluster**: ID `315`

---

## Section 10 – ELK Stack Access

1. Open Kibana at `http://YOUR_SERVER_IP:5601`
2. Navigate to **Stack Management → Index Patterns**
3. Create index pattern: `ecommerce-logs-*`
4. Set time field: `@timestamp`
5. Go to **Discover** to view logs

---

## Section 11 – AI Incident Analyzer

### 11.1 – Set up Python environment

```bash
cd ai/
python3 -m venv venv
source venv/bin/activate     # Linux/Mac
# venv\Scripts\activate      # Windows
pip install -r requirements.txt
```

### 11.2 – Set API Key

```bash
echo "OPENAI_API_KEY=your_key_here" >> ../.env
```

### 11.3 – Run Analyzer

```bash
# Analyze a log file
python incident_analyzer.py --log-file ../logs/app.log

# Analyze inline text
python incident_analyzer.py --log-text "Error: ECONNREFUSED 127.0.0.1:5432"

# Pipe from kubectl
kubectl logs deploy/ecommerce-app -n ecommerce | python incident_analyzer.py
```

---

## Section 12 – E-Commerce Application

### 12.1 – Add Your Application Code

The `app/` directory is where your e-commerce application source code goes.  
If you have an existing application:

```bash
# Copy your application files into the app/ directory
cp -r /path/to/your/ecommerce/app/* app/

# Ensure it has a package.json with:
#   "scripts": { "start": "...", "build": "...", "test": "..." }
# And exposes GET /api/health returning HTTP 200
```

### 12.2 – Update the Dockerfile

Edit [`docker/Dockerfile`](file:///c:/Users/prem/Desktop/Davine%20Technologies%20Internship/Project/Full%20CI%20CD/docker/Dockerfile) if your app's entry point differs from `dist/server.js`.

---

## Checklist Summary

Use this checklist to track progress:

- [ ] Linux server provisioned and hardened  
- [ ] SSH key authentication configured  
- [ ] Docker installed  
- [ ] Jenkins installed and configured  
- [ ] Jenkins credentials added  
- [ ] Jenkins pipeline job created  
- [ ] GitHub webhook configured  
- [ ] AWS account and IAM user created  
- [ ] AWS CLI configured  
- [ ] EC2 key pair created  
- [ ] S3 bucket + DynamoDB for Terraform state created  
- [ ] `terraform.tfvars` filled in  
- [ ] `terraform apply` completed  
- [ ] Ansible inventory configured  
- [ ] Ansible playbook executed  
- [ ] `kubectl` configured for EKS  
- [ ] NGINX Ingress Controller installed  
- [ ] Kubernetes manifests applied  
- [ ] Secrets replaced with real base64 values  
- [ ] Grafana dashboards imported  
- [ ] Kibana index pattern created  
- [ ] AI analyzer Python env set up  
- [ ] E-commerce application code placed in `app/`  
