variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access ports 9443, 443, and 6443"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "digitalis-kube-instance"
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 30
}
