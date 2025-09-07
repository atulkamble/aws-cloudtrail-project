terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Identity/region data
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Random suffix for bucket uniqueness
resource "random_id" "bucket" {
  byte_length = 3
}

# Only bucket_name_final here; common_tags is defined in locals.tf
locals {
  bucket_name_final = lower("${var.bucket_name_prefix}-${random_id.bucket.hex}")
}

# S3 public access hardening (bucket itself is in s3.tf)
resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
