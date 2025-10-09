<div align="center">

<img src="https://digitalis-marketplace-assets.s3.us-east-1.amazonaws.com/DigitalisDigital_DigitalisFullLogoGradient+-+medium.png" alt="Digitalis.io" width="400"/>

# Kubernetes-in-a-Box

### Enterprise-Ready Kubernetes Platform with Production-Grade Tools - Deployed in Minutes

[![Deploy to AWS](https://img.shields.io/badge/Deploy%20to-AWS-FF9900?style=for-the-badge&logo=amazon-aws)](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://cf-templates-436673215683-us-east-1.s3.us-east-1.amazonaws.com/dev-kube.yml)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.31-326CE5?style=for-the-badge&logo=kubernetes)](https://kubernetes.io)

[Quick Start](#-quick-start) • [Features](#-what-you-get) • [Documentation](#-documentation) • [Support](#-support)

</div>

---

## 🚀 What is This?

**Kubernetes-in-a-Box** by [Digitalis.io](https://digitalis.io) is a production-ready Kubernetes platform that deploys in **under 15 minutes**. No complex setup, no steep learning curve—just a complete, enterprise-grade container orchestration platform with monitoring, dashboards, GitOps, databases, and more.

Perfect for:
- 🏢 **Development teams** who need a quick Kubernetes environment for testing and development
- 🎓 **Learning Kubernetes** without the complexity of manual cluster setup
- 🚀 **Proof-of-concepts** and demos that need production-grade features
- 💼 **Small to medium workloads** that don't require a full managed Kubernetes service
- 🔬 **CI/CD pipelines** for testing containerized applications

### Why Choose This Over EKS/GKE/AKS?

| Feature | Kubernetes-in-a-Box | Managed K8s (EKS/GKE/AKS) |
|---------|---------------------|---------------------------|
| **Setup Time** | ⚡ ~15 minutes | 🐌 30-60+ minutes |
| **Cost** | 💰 ~$41/month (single t3.medium) | 💸 $75+ control plane + nodes |
| **Complexity** | 🎯 Web UI wizard | 📚 Complex CLI/Console setup |
| **Pre-installed Tools** | ✅ 10+ production tools included | ❌ Manual installation required |
| **Best For** | Dev, test, small workloads | Production at scale |

---

## ✨ What You Get

Deploy a **complete Kubernetes platform** with these production-grade tools pre-configured:

### 📦 Core Infrastructure
- **K3s** - Lightweight, certified Kubernetes distribution
- **cert-manager** - Automated SSL/TLS certificate management
- **Rancher Local Path Provisioner** - Dynamic persistent volume provisioning
- **Traefik Ingress** - Built-in load balancer and reverse proxy

### 🔍 Observability Stack
- **Prometheus** - Metrics collection and monitoring
- **Grafana** - Beautiful dashboards and alerting
- **Grafana Tempo** - Distributed tracing (optional)
- **CloudWatch Integration** - AWS native monitoring

### 🚀 DevOps & GitOps
- **ArgoCD** - GitOps continuous delivery for Kubernetes
- **Headlamp** - Modern Kubernetes web dashboard
- **code-server** - VS Code in your browser for remote development

### 🗄️ Database Options
- **MariaDB** (MySQL) + **phpMyAdmin** - Relational database with web UI
- **PostgreSQL** (CloudNativePG) + **pgAdmin** - Advanced relational database with web UI

### 🎨 Web-Based Configuration Wizard
- **Intuitive UI** - No Kubernetes knowledge required
- **One-click deployments** - Enable/disable features with checkboxes
- **Credential management** - Auto-generated passwords and tokens
- **Export configuration** - Download kubeconfig and credentials

---

## 🎯 Quick Start

### Option 1: Deploy with CloudFormation (Recommended)

The fastest way to get started:

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://cf-templates-436673215683-us-east-1.s3.us-east-1.amazonaws.com/dev-kube.yml)

**Prerequisites:**
- AWS Account with appropriate permissions
- VPC with internet connectivity
- Subnet (public or private with NAT)
- EC2 Key Pair

**Steps:**
1. Click the "Launch Stack" button above
2. Fill in the required parameters:
   - **Stack name**: Choose a name (e.g., `my-kubernetes-cluster`)
   - **AmiId**: Select the latest Kube AMI from your region
   - **InstanceType**: Choose instance size (t3.medium recommended)
   - **KeyName**: Select your EC2 key pair
   - **VpcId**: Select your VPC
   - **SubnetId**: Select your subnet
   - **AllowedSshCidr**: Your IP address or CIDR range (for security)
3. Click "Create Stack"
4. Wait ~10-15 minutes for deployment
5. Access the wizard URL from stack outputs

---

## 📊 Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         AWS Cloud                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                      VPC                                   │  │
│  │  ┌─────────────────────────────────────────────────────┐  │  │
│  │  │              EC2 Instance (K3s)                     │  │  │
│  │  │                                                     │  │  │
│  │  │  ┌─────────────────────────────────────────────┐  │  │  │
│  │  │  │         Configuration Wizard UI             │  │  │  │
│  │  │  │           https://<ip>:9443                 │  │  │  │
│  │  │  └─────────────────────────────────────────────┘  │  │  │
│  │  │                                                     │  │  │
│  │  │  ┌─────────────────────────────────────────────┐  │  │  │
│  │  │  │    Kubernetes Cluster (K3s)                 │  │  │  │
│  │  │  │  ┌─────────────┐  ┌──────────────────────┐ │  │  │  │
│  │  │  │  │   Ingress   │  │   Applications       │ │  │  │  │
│  │  │  │  │  (Traefik)  │  │  • ArgoCD            │ │  │  │  │
│  │  │  │  └─────────────┘  │  • Headlamp          │ │  │  │  │
│  │  │  │                   │  • Prometheus        │ │  │  │  │
│  │  │  │  ┌─────────────┐  │  • Grafana           │ │  │  │  │
│  │  │  │  │   Storage   │  │  • Databases         │ │  │  │  │
│  │  │  │  │ (Local Path)│  │  • code-server       │ │  │  │  │
│  │  │  │  └─────────────┘  └──────────────────────┘ │  │  │  │
│  │  │  └─────────────────────────────────────────────┘  │  │  │
│  │  │                                                     │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │                                                         │  │
│  │  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐  │  │
│  │  │  Security   │  │  IAM Role    │  │  Elastic IP  │  │  │
│  │  │    Group    │  │              │  │              │  │  │
│  │  └─────────────┘  └──────────────┘  └──────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎬 Getting Started

Once your stack is deployed:

### 1. Access the Configuration Wizard

Navigate to the Wizard URL from CloudFormation outputs:

```
https://<YOUR-INSTANCE-IP>:9443
```

**Note**: You may see a certificate warning (self-signed certificate). This is normal—click "Advanced" and proceed.

### 2. Configure Your Applications

The wizard provides an intuitive interface to:
- ✅ **Enable/disable** applications with checkboxes
- 🔧 **Configure** databases, monitoring, GitOps
- 👀 **Preview** what will be deployed
- 🚀 **Deploy** everything with one click

### 3. Monitor Deployment Progress

Watch real-time deployment logs as Ansible:
- 📦 Installs Helm charts
- 🔐 Configures certificates
- 🗄️ Sets up databases
- 📊 Deploys monitoring tools

### 4. Access Your Applications

After deployment completes, the success page shows:
- 🔑 **All credentials** and access tokens
- 🌐 **Application URLs** for all deployed services
- 📥 **Download buttons** for kubeconfig and complete configuration
- 🔒 **"Complete and Lock"** button to secure the wizard

### 5. Download Your Credentials

**Important**: Download and save:
- `config.yml` - Complete configuration with all credentials
- `kubeconfig` - Kubernetes cluster access configuration

Then click **"Complete and Lock Wizard"** to secure the system.

---

## 🛠️ Usage Examples

### Connect with kubectl

```bash
# Download kubeconfig from the wizard
export KUBECONFIG=~/Downloads/kubeconfig

# Verify cluster access
kubectl get nodes
kubectl get pods -A

# Deploy a sample application
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=ClusterIP
```

### Access Kubernetes Dashboard (Headlamp)

```bash
# Get the Headlamp URL from success page
open https://headlamp.<YOUR-IP>.nip.io

# Use the token from config.yml to log in
```

### Deploy with ArgoCD (GitOps)

```bash
# Access ArgoCD UI
open https://argocd.<YOUR-IP>.nip.io

# Login with credentials from config.yml
# Username: admin
# Password: <from config.yml>

# Connect your Git repository and deploy applications
```

### Query Metrics with Prometheus

```bash
# Access Grafana
open https://grafana.<YOUR-IP>.nip.io

# Login with default credentials (admin/prom-operator)
# Explore pre-configured dashboards for:
# - Kubernetes cluster metrics
# - Node exporter metrics
# - Application metrics
```

### Use Database

```bash
# MariaDB (if enabled):
open https://phpmyadmin.<YOUR-IP>.nip.io

# PostgreSQL (if enabled):
open https://pgadmin.<YOUR-IP>.nip.io

# Credentials are in config.yml
```

---

## 💰 Cost Estimation

**Monthly costs** (us-east-1 region):

| Component | Cost |
|-----------|------|
| **t3.medium** (2 vCPU, 4GB RAM) | ~$30.37 |
| **50 GB gp3 volume** | ~$4.00 |
| **Elastic IP** | Free (while attached) |
| **CloudWatch monitoring** | ~$7.00 (if enabled) |
| **Data transfer** | Variable |
| **Total (approx)** | **~$41-45/month** |

**Cost Optimization Tips:**
- 💡 Use **t4g.medium** (ARM) for ~20% savings: **~$24.55/month**
- 🌙 Stop instances during off-hours for dev/test environments
- 📊 Disable detailed monitoring if not needed: save ~$7/month
- 🔄 Use Spot Instances for non-production: save up to 70%

**Compare to Managed Kubernetes:**
- **AWS EKS**: $73/month (control plane) + $30/month (node) = **$103+/month**
- **Savings**: **60% less** than managed Kubernetes

---

## 🔧 Troubleshooting

### Cannot Access Wizard

```bash
# Check wizard service status
ssh -i ~/.ssh/YOUR-KEY.pem ubuntu@<INSTANCE-IP>
sudo systemctl status kube-wizard

# View logs
sudo journalctl -u wizard -f
```

### Kubernetes Cluster Issues

```bash
# Check K3s status
sudo systemctl status k3s

# View K3s logs
sudo journalctl -u k3s -f

# Check cluster health
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl get nodes
kubectl get pods -A
```

## 📞 Support

### Community Support
- 📖 [Documentation](https://docs.digitalis.io)
- 💬 [GitHub Discussions](https://github.com/digitalis-io/ami-kube/discussions)
- 🐛 [Issue Tracker](https://github.com/digitalis-io/ami-kube/issues)

### Professional Support
For enterprise support, training, and consulting:
- 🌐 Visit [Digitalis.io](https://digitalis.io)
- 📧 Email [support@digitalis.io](mailto:support@digitalis.io)
- 💼 [Contact Us](https://digitalis.io/contact) for custom solutions

### About Digitalis.io

[Digitalis.io](https://digitalis.io) specializes in cloud-native solutions, Kubernetes consulting, and DevOps transformation. We help organizations:
- 🚀 Adopt Kubernetes and containerization
- 📊 Implement observability and monitoring
- 🔄 Establish CI/CD pipelines
- 🔒 Secure cloud infrastructure
- 📈 Scale applications efficiently

</div>
