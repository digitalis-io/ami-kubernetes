# Terraform AWS Module Usage Guide

## Overview

This Terraform module deploys the Digitalis Kubernetes-in-a-Box AMI on AWS. It creates an EC2 instance with K3s pre-installed along with all necessary infrastructure components including security groups, networking configuration, and optimized storage.

## Prerequisites

Before using this module, ensure you have:

- **Terraform** >= 1.0 installed
- **AWS CLI** configured with appropriate credentials
- **AWS Account** with permissions to create:
  - EC2 instances
  - Security groups
  - VPC resources
- **Existing AWS Resources**:
  - VPC with internet connectivity
  - Subnet (public or private with NAT gateway)
  - EC2 Key Pair for SSH access

## Quick Start

### Basic Usage

Create a `main.tf` file in your project directory:

```hcl
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "kubernetes_in_a_box" {
  source = "./terraform/aws"

  # Required variables
  key_name  = "my-ec2-keypair"
  subnet_id = "subnet-0123456789abcdef0"
  vpc_id    = "vpc-0123456789abcdef0"

  # Optional variables with recommended values
  region             = "us-east-1"
  instance_type      = "t3.medium"
  instance_name      = "digitalis-kube-instance"
  root_volume_size   = 50
  allowed_cidr_blocks = ["YOUR_IP_ADDRESS/32"]  # Replace with your IP
}

# Output the instance details
output "instance_public_ip" {
  description = "Public IP to access the Kubernetes cluster and wizard"
  value       = module.kubernetes_in_a_box.instance_public_ip
}

output "wizard_url" {
  description = "URL to access the configuration wizard"
  value       = "https://${module.kubernetes_in_a_box.instance_public_ip}:9443"
}

output "ami_used" {
  description = "AMI ID and name used for deployment"
  value = {
    id   = module.kubernetes_in_a_box.ami_id
    name = module.kubernetes_in_a_box.ami_name
  }
}
```

### Deploy the Infrastructure

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply

# Note the outputs (especially the wizard_url)
```

## Configuration Options

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `key_name` | string | Name of the EC2 SSH key pair for instance access |
| `subnet_id` | string | Subnet ID where the instance will be launched |
| `vpc_id` | string | VPC ID for the security group |

### Optional Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `region` | string | `"us-east-1"` | AWS region for deployment |
| `instance_type` | string | `"t3.medium"` | EC2 instance type (min: 2 vCPU, 4GB RAM) |
| `instance_name` | string | `"digitalis-kube-instance"` | Name tag for the EC2 instance |
| `root_volume_size` | number | `30` | Size of root volume in GB (min: 30GB) |
| `allowed_cidr_blocks` | list(string) | `["0.0.0.0/0"]` | CIDR blocks allowed access to ports 443, 6443, 9443 |

### Outputs

| Output | Description |
|--------|-------------|
| `instance_id` | EC2 instance ID |
| `instance_public_ip` | Public IP address of the instance |
| `instance_private_ip` | Private IP address of the instance |
| `security_group_id` | ID of the created security group |
| `ami_id` | ID of the AMI used |
| `ami_name` | Name of the AMI used |

## Advanced Examples

### Production Configuration with Restricted Access

```hcl
module "kubernetes_in_a_box_prod" {
  source = "./terraform/aws"

  # Network configuration
  vpc_id    = "vpc-0123456789abcdef0"
  subnet_id = "subnet-0123456789abcdef0"
  key_name  = "production-keypair"

  # Instance configuration
  region           = "us-west-2"
  instance_type    = "t3.large"  # More resources for production
  instance_name    = "prod-kubernetes-cluster"
  root_volume_size = 100  # Larger storage for production workloads

  # Security: Restrict access to your office IP and VPN
  allowed_cidr_blocks = [
    "203.0.113.0/24",  # Office network
    "198.51.100.0/24"  # VPN network
  ]
}
```

### Development Environment with Cost Optimization

```hcl
module "kubernetes_in_a_box_dev" {
  source = "./terraform/aws"

  vpc_id    = data.aws_vpc.default.id
  subnet_id = data.aws_subnet.default.id
  key_name  = "dev-keypair"

  region           = "us-east-1"
  instance_type    = "t3.medium"
  instance_name    = "dev-kubernetes"
  root_volume_size = 30  # Minimum for development

  # Open access for development (not recommended for production)
  allowed_cidr_blocks = ["0.0.0.0/0"]
}

# Use default VPC for development
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "${var.region}a"
  default_for_az    = true
}
```

### Multi-Environment Deployment with Workspaces

```hcl
# main.tf
locals {
  environment = terraform.workspace

  instance_config = {
    dev = {
      instance_type    = "t3.medium"
      root_volume_size = 30
      allowed_cidr     = ["0.0.0.0/0"]
    }
    staging = {
      instance_type    = "t3.large"
      root_volume_size = 50
      allowed_cidr     = ["10.0.0.0/8"]
    }
    prod = {
      instance_type    = "t3.xlarge"
      root_volume_size = 100
      allowed_cidr     = ["10.0.0.0/8"]
    }
  }
}

module "kubernetes_in_a_box" {
  source = "./terraform/aws"

  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id
  key_name  = var.key_name

  instance_type       = local.instance_config[local.environment].instance_type
  instance_name       = "${local.environment}-kubernetes-cluster"
  root_volume_size    = local.instance_config[local.environment].root_volume_size
  allowed_cidr_blocks = local.instance_config[local.environment].allowed_cidr
}
```

Deploy different environments:
```bash
# Development
terraform workspace new dev
terraform apply

# Staging
terraform workspace new staging
terraform apply

# Production
terraform workspace new prod
terraform apply
```

### Using with Remote Backend

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "kubernetes/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.region
}

module "kubernetes_in_a_box" {
  source = "./terraform/aws"

  vpc_id              = var.vpc_id
  subnet_id           = var.subnet_id
  key_name            = var.key_name
  instance_type       = var.instance_type
  allowed_cidr_blocks = var.allowed_cidr_blocks
}
```

## Security Best Practices

### 1. Restrict Network Access

Always limit `allowed_cidr_blocks` to known IP addresses:

```hcl
allowed_cidr_blocks = [
  "203.0.113.10/32",  # Your IP
  "198.51.100.0/24"   # Your company network
]
```

Get your current IP:
```bash
curl -s https://checkip.amazonaws.com
```

### 2. Use Private Subnets

For production, deploy in a private subnet with a NAT gateway:

```hcl
module "kubernetes_in_a_box" {
  source = "./terraform/aws"

  # Private subnet with NAT gateway for outbound internet
  subnet_id = "subnet-private-123456"
  vpc_id    = "vpc-0123456789abcdef0"

  # Access only from VPN or bastion host
  allowed_cidr_blocks = ["10.0.0.0/16"]

  # ... other configuration
}
```

### 3. Enable AWS CloudTrail

Monitor Terraform changes by enabling CloudTrail:

```hcl
resource "aws_cloudtrail" "kubernetes_audit" {
  name           = "kubernetes-terraform-audit"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}
```

### 4. Use IAM Instance Profile

Consider attaching an IAM role for AWS service integration:

```hcl
resource "aws_iam_role" "kube_instance_role" {
  name = "kubernetes-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "kube_profile" {
  name = "kubernetes-instance-profile"
  role = aws_iam_role.kube_instance_role.name
}

# Note: The module would need to be updated to accept iam_instance_profile
```

## Networking Configuration

### Ports and Security Groups

The module automatically creates a security group with the following rules:

| Port | Protocol | Purpose |
|------|----------|---------|
| 443 | TCP | HTTPS access for applications |
| 6443 | TCP | Kubernetes API Server |
| 9443 | TCP | Configuration Wizard UI |
| All | All | Outbound traffic (egress) |

### DNS Configuration

The wizard uses `nip.io` for automatic DNS:
- Applications accessible at: `https://app-name.<instance-ip>.nip.io`
- No additional DNS configuration required

For production, consider using Route53:

```hcl
resource "aws_route53_record" "kubernetes" {
  zone_id = var.route53_zone_id
  name    = "kubernetes.example.com"
  type    = "A"
  ttl     = 300
  records = [module.kubernetes_in_a_box.instance_public_ip]
}
```

## Cost Optimization

### Instance Types Comparison

| Instance Type | vCPU | RAM | Price/month (us-east-1) | Use Case |
|---------------|------|-----|-------------------------|----------|
| t3.medium | 2 | 4 GB | ~$30 | Development, testing |
| t3.large | 2 | 8 GB | ~$60 | Small production |
| t3.xlarge | 4 | 16 GB | ~$121 | Production workloads |
| t4g.medium (ARM) | 2 | 4 GB | ~$24 | Cost-optimized dev |

### Reduce Costs for Non-Production

```hcl
# Use smaller instance for development
module "kubernetes_in_a_box_dev" {
  source = "./terraform/aws"

  instance_type    = "t3.small"  # Minimal viable size
  root_volume_size = 30           # Minimum storage

  # ... other configuration
}
```

Schedule to stop instances during off-hours:
```bash
# Stop instance at 7 PM
aws ec2 stop-instances --instance-ids $(terraform output -raw instance_id)

# Start instance at 8 AM
aws ec2 start-instances --instance-ids $(terraform output -raw instance_id)
```

## Troubleshooting

### Common Issues

#### Issue: "InvalidKeyPair.NotFound"

**Error**: The key pair does not exist in the specified region.

**Solution**:
```bash
# List available key pairs
aws ec2 describe-key-pairs --region us-east-1

# Or create a new key pair
aws ec2 create-key-pair --key-name my-keypair --region us-east-1 \
  --query 'KeyMaterial' --output text > my-keypair.pem
chmod 400 my-keypair.pem
```

#### Issue: "InvalidSubnet.NotFound"

**Error**: The subnet does not exist or is in a different region.

**Solution**:
```bash
# List subnets in your VPC
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-xxxx" --region us-east-1
```

#### Issue: Cannot access wizard on port 9443

**Possible causes**:
1. Security group not allowing your IP
2. Instance still booting
3. Wizard service not started

**Solution**:
```bash
# Check instance status
aws ec2 describe-instance-status --instance-ids i-xxxxx

# SSH into instance and check wizard service
ssh -i your-key.pem ubuntu@<instance-ip>
sudo systemctl status wizard
sudo journalctl -u wizard -f
```

#### Issue: AMI not found

**Error**: No AMIs found matching the filter.

**Possible cause**: AMI not available in your region.

**Solution**: Check AMI availability or contact Digitalis.io for region-specific AMI IDs.

## Maintenance and Updates

### Updating the Instance

To update to a new AMI version:

```bash
# 1. Backup important data
kubectl get all -A -o yaml > cluster-backup.yaml

# 2. Plan the update (Terraform will recreate the instance)
terraform plan

# 3. Apply the update
terraform apply

# 4. Reconfigure using the wizard at the new IP address
```

### Destroying Resources

To remove all resources:

```bash
# Preview what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy

# Confirm by typing 'yes'
```

**Warning**: This will permanently delete the instance and all data. Ensure you have backups of any important data.

## Next Steps

After deploying with Terraform:

1. **Access the wizard**: Navigate to `https://<instance-ip>:9443`
2. **Configure applications**: Use the web UI to enable desired features
3. **Download credentials**: Save `config.yml` and `kubeconfig`
4. **Lock the wizard**: Complete setup and secure the system
5. **Connect with kubectl**: Use the downloaded kubeconfig

For detailed post-deployment steps, see the main [README.md](../README.md#-getting-started).

## Additional Resources

- [Main Documentation](../README.md)
- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Digitalis.io Website](https://digitalis.io)
- [Support](mailto:support@digitalis.io)

## Contributing

To modify this module:

1. Make changes to the Terraform files
2. Format the code: `terraform fmt -recursive`
3. Validate: `terraform validate`
4. Test in a development environment
5. Update this documentation as needed

## License

This module is part of the Kubernetes-in-a-Box project.
See [LICENSE](../LICENSE) for details.
