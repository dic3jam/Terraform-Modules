output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "swarm_managers_ips" {
  value = aws_instance.swarm-manager[*].private_ip
}

output "swarm_workers_ips" {
  value = aws_instance.swarm[*].private_ip
}

output "target_instance_id" {
  # this needs to be fixed for multiple targets to ALB
  value = aws_instance.swarm-manager[0].id
}