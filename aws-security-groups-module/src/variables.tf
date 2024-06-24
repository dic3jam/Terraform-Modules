variable "Name" {
  description = "This project's name"
}

variable "Billing-Tag" {
  description = "The billing tag for this project"
}

variable "Environment-Tag" {
  description = "The environment for this project"
}

variable vpc_cidr_block {
  type = string
  description = "The cidr block for which the security groups are valid"
}

variable vpc_id {
  description = "The id of the VPC"
}