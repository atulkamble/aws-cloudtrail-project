# kms.tf — updated with key policy for CloudTrail

data "aws_iam_policy_document" "cloudtrail_kms" {
  # 1) Full admin on the key to the account root
  statement {
    sid     = "EnableRootPermissions"
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # 2) Allow the CloudTrail service to encrypt logs with this key
  #    (Scoped to any trail in THIS account; region-wildcard is OK)
  statement {
    sid     = "AllowCloudTrailEncrypt"
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
    }
  }
}

resource "aws_kms_key" "cloudtrail" {
  description             = "KMS key for CloudTrail logs"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.cloudtrail_kms.json
  tags                    = local.common_tags
}

resource "aws_kms_alias" "cloudtrail" {
  name          = "alias/cloudtrail-key"
  target_key_id = aws_kms_key.cloudtrail.key_id
}
