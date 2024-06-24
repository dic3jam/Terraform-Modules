variable "Name" {
  description = "This project's name"
}

variable "Billing-Tag" {
  description = "The billing tag for this project"
}

variable "Environment-Tag" {
  description = "The environment for this project"
}

variable "ALB-ARN" {
  type = string
  description = "The ARN of the ALB"
}
