resource "aws_kms_key" "cloudtrail" {
description = "KMS key for CloudTrail logs"
enable_key_rotation = true
deletion_window_in_days = 7
tags = local.common_tags
}


resource "aws_kms_alias" "cloudtrail" {
name = "alias/cloudtrail-key"
target_key_id = aws_kms_key.cloudtrail.key_id
}
