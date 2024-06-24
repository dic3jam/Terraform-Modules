resource "aws_acm_certificate" "basic-acm" {
  domain_name       = var.domain-name
  validation_method = "DNS"
  tags = {
      Name = join("-", [var.Name], ["-ACM"])
      Billing = var.Billing-Tag
      Environment = var.Environment-Tag
    }
}
