variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "trail_name" {
  description = "CloudTrail name"
  type        = string
  default     = "cloudnautic-cloudtrail"
}

# Instead of a fixed bucket name, use this prefix and a random suffix
variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name (must be lowercase, no spaces). A random suffix will be added."
  type        = string
  default     = "cloudnautic-cloudtrail-logs"
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention days"
  type        = number
  default     = 90
}

variable "enable_athena" {
  description = "Create Athena/Glue resources for querying CloudTrail logs"
  type        = bool
  default     = false
}
