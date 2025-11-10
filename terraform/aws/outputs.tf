output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.kube_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.kube_instance.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.kube_instance.private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.kube_sg.id
}

output "ami_id" {
  description = "ID of the AMI used"
  value       = data.aws_ami.marketplace_ami.id
}

output "ami_name" {
  description = "Name of the AMI used"
  value       = data.aws_ami.marketplace_ami.name
}
