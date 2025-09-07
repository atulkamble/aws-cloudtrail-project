terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Helpful identity/region data
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Common tags applied where supported
locals {
  common_tags = {
    project     = "aws-cloudtrail-project"
    owner       = "cloudnautic"
    region      = data.aws_region.current.name
    account_id  = data.aws_caller_identity.current.account_id
    managed_by  = "terraform"
  }
}

# --- S3 public access hardening for the CloudTrail logs bucket ---
# (Bucket, versioning, policy are defined in s3.tf)
resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# You can attach common tags to resources that support tags in their own files, e.g.:
#   tags = local.common_tags
#
# Other resources are split into:
# - providers.tf     -> provider "aws" with region variable
# - kms.tf           -> aws_kms_key + alias for encryption
# - iam.tf           -> IAM role/policy attachments (if needed)
# - cloudwatch.tf    -> aws_cloudwatch_log_group for real-time streaming
# - cloudtrail.tf    -> aws_cloudtrail main trail (multi-region, log validation, CW logs)
# - s3.tf            -> aws_s3_bucket + versioning + bucket policy for CloudTrail
# - outputs.tf       -> surface trail name, bucket, log group, kms key, etc.
