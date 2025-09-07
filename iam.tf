# iam.tf — CloudTrail → CloudWatch Logs integration

# IAM role that CloudTrail assumes to deliver events into CloudWatch Logs
resource "aws_iam_role" "cloudtrail_cwlogs" {
  name = "cloudtrail-to-cwlogs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "cloudtrail.amazonaws.com" },
      Action   = "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

# IAM policy document for CloudTrail log delivery
data "aws_iam_policy_document" "cloudtrail_cwlogs" {
  # Permissions on the log group itself
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = [
      aws_cloudwatch_log_group.cloudtrail.arn
    ]
  }

  # Permissions on log streams inside the group
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
    ]
  }
}

# Inline policy attached to the role
resource "aws_iam_role_policy" "cloudtrail_cwlogs" {
  name   = "cloudtrail-to-cwlogs-policy"
  role   = aws_iam_role.cloudtrail_cwlogs.id
  policy = data.aws_iam_policy_document.cloudtrail_cwlogs.json
}
