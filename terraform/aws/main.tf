# Data source for the marketplace AMI
data "aws_ami" "marketplace_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["digitalis-kube*"]
  }

  owners = ["aws-marketplace", "679593333241"]
}

# Security group for Kubernetes API and management
resource "aws_security_group" "kube_sg" {
  name        = "digitalis-kube-sg"
  description = "Allow access to Kubernetes API and management ports"
  vpc_id      = var.vpc_id

  # Port 443 - HTTPS
  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Port 6443 - Kubernetes API Server
  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Port 9443 - Custom management port
  ingress {
    description = "Management port"
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

# EC2 instance
resource "aws_instance" "kube_instance" {
  ami           = data.aws_ami.marketplace_ami.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.kube_sg.id]

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name = var.instance_name
  }
}
