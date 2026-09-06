output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.coolify.id
}

output "public_ip" {
  description = "Public IP address"
  value       = var.allocate_eip ? aws_eip.coolify[0].public_ip : aws_instance.coolify.public_ip
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.coolify.private_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.coolify.id
}

output "coolify_url" {
  description = "Coolify dashboard URL"
  value       = "http://${var.allocate_eip ? aws_eip.coolify[0].public_ip : aws_instance.coolify.public_ip}:8000"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i <your-key>.pem ubuntu@${var.allocate_eip ? aws_eip.coolify[0].public_ip : aws_instance.coolify.public_ip}"
}
