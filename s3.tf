resource "aws_s3_bucket" "cloudtrail" {
bucket = var.bucket_name
force_destroy = true
tags = local.common_tags
}


resource "aws_s3_bucket_ownership_controls" "this" {
bucket = aws_s3_bucket.cloudtrail.id
rule {
object_ownership = "BucketOwnerPreferred"
}
}


resource "aws_s3_bucket_acl" "this" {
bucket = aws_s3_bucket.cloudtrail.id
acl = "private"
depends_on = [aws_s3_bucket_ownership_controls.this]
}


resource "aws_s3_bucket_versioning" "cloudtrail" {
bucket = aws_s3_bucket.cloudtrail.id
versioning_configuration { status = "Enabled" }
}


resource "aws_s3_bucket_public_access_block" "cloudtrail" {
bucket = aws_s3_bucket.cloudtrail.id
block_public_acls = true
block_public_policy = true
ignore_public_acls = true
restrict_public_buckets = true
}


# Minimal bucket policy for CloudTrail delivery
data "aws_iam_policy_document" "cloudtrail_bucket" {
statement {
sid = "CloudTrailAclCheck"
effect = "Allow"
principals { type = "Service", identifiers = ["cloudtrail.amazonaws.com"] }
actions = ["s3:GetBucketAcl"]
resources = [aws_s3_bucket.cloudtrail.arn]
}


statement {
sid = "CloudTrailWrite"
effect = "Allow"
principals { type = "Service", identifiers = ["cloudtrail.amazonaws.com"] }
actions = ["s3:PutObject"]
resources = ["${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
condition {
test = "StringEquals"
variable = "s3:x-amz-acl"
values = ["bucket-owner-full-control"]
}
}
}


resource "aws_s3_bucket_policy" "cloudtrail" {
bucket = aws_s3_bucket.cloudtrail.id
policy = data.aws_iam_policy_document.cloudtrail_bucket.json
}
