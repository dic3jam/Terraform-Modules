resource "aws_kms_key" "basic-SSM-Key" {
  multi_region = true

  tags = {
      Name = "basic-SSM-Key"
      Billing = var.Billing-Tag
    }
}

resource "aws_kms_key" "basic-SSM-Log-Key" {
  multi_region = true

  tags = {
      Name = "basic-SSM-Log-Key"
      Billing = var.Billing-Tag
    }
}

resource "aws_kms_key" "basic-Backup-Key" {
  multi_region = true

  tags = {
      Name = "basic-Backup-Key"
      Billing = var.Billing-Tag
    }
}