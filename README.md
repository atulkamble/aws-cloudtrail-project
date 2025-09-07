# 📜 AWS CloudTrail Project

This project provisions a secure and auditable **AWS CloudTrail** setup using Terraform. It covers:

* S3 bucket for storing logs (with encryption & lifecycle rules).
* KMS key for log encryption.
* CloudTrail trail with multi-region enabled.
* CloudWatch Logs integration for real-time monitoring.
* IAM roles & policies.
* Optional Athena setup for querying logs.

---

## 📂 Repository Structure

```
aws-cloudtrail-project/
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf (optional for remote state)
├── providers.tf
├── s3.tf
├── kms.tf
├── cloudtrail.tf
├── cloudwatch.tf
├── iam.tf
├── athena.tf (optional)
└── README.md
```
```
git clone git@github.com:atulkamble/aws-cloudtrail-project.git
cd aws-cloudtrail-project\n
terraform init
terraform plan
terraform apply
terraform destroy
```

---

## 🚀 Steps to Deploy

### 1️⃣ Prerequisites

* AWS account with admin permissions
* Terraform installed (`>=1.5`)
* AWS CLI configured (`aws configure`)

### 2️⃣ Initialize Terraform

```bash
terraform init
```

### 3️⃣ Validate Configuration

```bash
terraform validate
```

### 4️⃣ Plan Infrastructure

```bash
terraform plan -out=tfplan
```

### 5️⃣ Apply Infrastructure

```bash
terraform apply tfplan
```

### 6️⃣ Destroy (Cleanup)

```bash
terraform destroy
```

---

## 📝 Terraform Code Examples

### providers.tf

```hcl
provider "aws" {
  region = var.region
}
```

### variables.tf

```hcl
variable "region" {
  default = "us-east-1"
}

variable "trail_name" {
  default = "cloudnautic-cloudtrail"
}

variable "bucket_name" {
  default = "cloudnautic-cloudtrail-logs"
}
```

### s3.tf

```hcl
resource "aws_s3_bucket" "cloudtrail" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid       = "AWSCloudTrailAclCheck"
    effect    = "Allow"
    principals { type = "Service", identifiers = ["cloudtrail.amazonaws.com"] }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail.arn]
  }

  statement {
    sid       = "AWSCloudTrailWrite"
    effect    = "Allow"
    principals { type = "Service", identifiers = ["cloudtrail.amazonaws.com"] }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail.arn}/AWSLogs/*"]
  }
}
```

### kms.tf

```hcl
resource "aws_kms_key" "cloudtrail" {
  description             = "KMS key for CloudTrail logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "cloudtrail" {
  name          = "alias/cloudtrail-key"
  target_key_id = aws_kms_key.cloudtrail.key_id
}
```

### iam.tf

```hcl
resource "aws_iam_role" "cloudtrail" {
  name = "cloudtrail_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
      Action   = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudtrail" {
  role       = aws_iam_role.cloudtrail.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCloudTrailRole"
}
```

### cloudtrail.tf

```hcl
resource "aws_cloudtrail" "main" {
  name                          = var.trail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail.bucket
  kms_key_id                    = aws_kms_key.cloudtrail.arn
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudtrail.arn
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail.arn
}
```

### cloudwatch.tf

```hcl
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${var.trail_name}"
  retention_in_days = 90
}
```

### athena.tf (Optional)

```hcl
resource "aws_glue_catalog_database" "cloudtrail" {
  name = "cloudtrail_logs"
}

resource "aws_glue_catalog_table" "cloudtrail" {
  name          = "events"
  database_name = aws_glue_catalog_database.cloudtrail.name

  table_type = "EXTERNAL_TABLE"
  storage_descriptor {
    location      = "s3://${var.bucket_name}/AWSLogs/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }
  }
}
```

---

## ✅ Validation Steps

1. Log in to **AWS Console → CloudTrail → Trails** → Check if trail is active.
2. Go to **S3 → bucket** → Verify logs.
3. Check **CloudWatch Logs → /aws/cloudtrail/** → Real-time events.
4. Run Athena query if enabled.

---

## 📌 Notes

* Ensure S3 bucket names are unique globally.
* Athena setup requires manually creating a workgroup and query results bucket.
* You can expand this project with EventBridge rules for security alerts.

---

👨‍💻 Author: Atul Kamble — *Cloud Solutions Architect*
