variable "region" {
description = "AWS region"
type = string
default = "us-east-1"
}


variable "trail_name" {
description = "CloudTrail name"
type = string
default = "cloudnautic-cloudtrail"
}


variable "bucket_name" {
description = "S3 bucket for CloudTrail logs (must be globally unique)"
type = string
default = "cloudnautic-cloudtrail-logs-123456"
}


variable "log_retention_days" {
description = "CloudWatch Logs retention"
type = number
default = 90
}


variable "enable_athena" {
description = "Create Athena/Glue resources"
type = bool
default = false
}
