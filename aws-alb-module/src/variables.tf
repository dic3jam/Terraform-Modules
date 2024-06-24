variable "Name" {
  description = "This project's name"
}

variable "Billing-Tag" {
  description = "The billing tag for this project"
}

variable "Environment-Tag" {
  description = "The environment for this project"
}

variable "ACM_ARN" {
  description = "The ARN of the ACM certificate"
}

variable "protocol" {
  description = "HTTP or HTTPS for the ALB listener"
  default = "HTTP"

  validation {
    condition = contains(["HTTP", "HTTPS"], var.protocol)
    error_message = "The protocol must be either HTTP or HTTPS."
  }
}

variable vpc_id {
  description = "VPC ID"
}

variable target_instance_id {
  type = string
  description = "The instance we want the load balancer to target"
}

variable public_subnets {
  type = list(string)
  description = "The public subnets the load balancer needs access to"
}