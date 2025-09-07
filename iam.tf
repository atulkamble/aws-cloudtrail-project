# Role assumed by CloudTrail to write to CloudWatch Logs
resource "aws_iam_role" "cloudtrail_cwlogs" {
name = "cloudtrail-to-cwlogs-role"
assume_role_policy = jsonencode({
Version = "2012-10-17",
Statement = [{
Effect = "Allow",
Principal = { Service = "cloudtrail.amazonaws.com" },
Action = "sts:AssumeRole"
}]
})
tags = local.common_tags
}


# Inline policy: allow writing to the specific log group streams
data "aws_iam_policy_document" "cloudtrail_cwlogs" {
statement {
effect = "Allow"
actions = [
"logs:CreateLogStream",
"logs:PutLogEvents"
]
resources = ["${aws_cloudwatch_log_group.cloudtrail.arn}:*"]
}
}


resource "aws_iam_role_policy" "cloudtrail_cwlogs" {
name = "cloudtrail-to-cwlogs-policy"
role = aws_iam_role.cloudtrail_cwlogs.id
policy = data.aws_iam_policy_document.cloudtrail_cwlogs.json
}
