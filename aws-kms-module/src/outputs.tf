output "basic_SSM_KEY" {
  value = aws_kms_key.basic-SSM-Key
}

output "basic_SSM_LOG_KEY" {
  value = aws_kms_key.basic-SSM-Log-Key
}

output "basic_BACKUP_KEY" {
  value = aws_kms_key.basic-Backup-Key
}