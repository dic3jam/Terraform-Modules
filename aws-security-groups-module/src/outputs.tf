output "sg_allow_ssh" {
  value = aws_security_group.sg_allow_ssh
}

output "sg_basic_web_80" {
  value = aws_security_group.sg_basic_web_80
}

output "sg_basic_web_8080" {
  value = aws_security_group.sg_basic_web_8080
}

output "sg_basic_docker_swarm" {
  value = aws_security_group.sg_basic_docker_swarm
}

output "sg_basic_gluster" {
  value = aws_security_group.sg_basic_gluster
}