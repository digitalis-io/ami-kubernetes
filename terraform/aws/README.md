# Digitalis Kubernetes Terraform Configuration

This Terraform configuration deploys an EC2 instance using the Digitalis Kubernetes marketplace AMI with appropriate security group rules.

## Prerequisites

- Terraform >= 1.0
- AWS credentials configured
- Existing VPC and subnet
- SSH key pair created in AWS

## Configuration

1. Copy the example tfvars file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   - `vpc_id`: Your VPC ID
   - `subnet_id`: Your subnet ID
   - `key_name`: Your SSH key pair name
   - `allowed_cidr_blocks`: CIDR blocks allowed to access ports 9443, 443, and 6443

## Security Group Rules

The configuration creates a security group with the following ingress rules:
- **Port 443**: HTTPS access
- **Port 6443**: Kubernetes API Server
- **Port 9443**: Management port

All ports are accessible only from the CIDR blocks specified in `allowed_cidr_blocks`.

## Usage

Initialize Terraform:
```bash
terraform init
```

Review the plan:
```bash
terraform plan
```

Apply the configuration:
```bash
terraform apply
```

## Outputs

After deployment, the following outputs are available:
- `instance_id`: EC2 instance ID
- `instance_public_ip`: Public IP address
- `instance_private_ip`: Private IP address
- `security_group_id`: Security group ID
- `ami_id`: AMI ID used
- `ami_name`: AMI name

## Cleanup

To destroy the resources:
```bash
terraform destroy
```
