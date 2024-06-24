variable "Name" {
  description = "This project's name"
}

variable "Billing-Tag" {
  description = "The billing tag for this project"
}

variable "Environment-Tag" {
  description = "The environment for this project"
}

variable "Availability-Zone" {
  type = list(string)
  description = "The availability zone for this project"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnets" {
  type = list(string)
  description = "the public subnet cidrs"
}

variable "private_subnets" {
  type = list(string)
}

variable "swarm_manager_count" {
  type = number
  description = "the number of swarm managers"
}

variable "swarm_worker_count" {
  type = number
  description = "the number of swarm workers"
}

variable "ami" {
  type = string
  description = "the ami to use"
}

variable "instance_type" {
  type = string
  description = "this will set the instance type for the swarm and manager nodes."
}

variable "EBS-Key" {
  type = string
  description = "The key used for EBS encryption on the instances volumes. This must be created manually prior to using this module. There should be 1 EBS designated key per account - and that will apply to all instances in that account. This module makes a separate KMS key unique to instances in this VPC."
}

variable "SSHPUB" {
  type = string
  description = "This is the fingerprint of a SSH key you generate on your local machine. The domain\\user@localhost portion is irrelevant. Ensure that the private key portion makes its way to Keeper. This is linked in the pipeline, so set the CI/CD variable 'SSh_PUB_KEY'."
}

variable "iam_profile" {
  type = string
  description = "The name of the IAM instance profile to associate. It should always be named "
  default = "basic_EC2"
}

variable "bastion-security-groups" {
  description = "The security groups to apply to the bastion host"
}


variable "swarm-security-groups" {
  description = "The security groups to apply to the swarm hosts and managers"
}

variable "volume_size" {
  type = number
  description = "Size of the volumes on the swarm manager/hosts"
}
