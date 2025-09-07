output "trail_name" { value = aws_cloudtrail.main.name }
output "logs_bucket" { value = aws_s3_bucket.cloudtrail.bucket }
output "log_group" { value = aws_cloudwatch_log_group.cloudtrail.name }
output "kms_key_arn" { value = aws_kms_key.cloudtrail.arn }
