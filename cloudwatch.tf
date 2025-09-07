resource "aws_cloudwatch_log_group" "cloudtrail" {
name = "/aws/cloudtrail/${var.trail_name}"
retention_in_days = var.log_retention_days
tags = local.common_tags
}
