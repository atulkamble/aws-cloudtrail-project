# 📜 AWS CloudTrail Project

This project provisions a secure and auditable **AWS CloudTrail** setup using Terraform. It covers:

* S3 bucket for storing logs (with encryption & lifecycle rules).
* KMS key for log encryption.
* CloudTrail trail with multi-region enabled.
* CloudWatch Logs integration for real-time monitoring.
* IAM roles & policies.
* Optional Athena setup for querying logs.

```
git clone https://github.com/atulkamble/aws-cloudtrail-project.git
cd aws-cloudtrail-project
terraform init
terraform plan
terraform apply
terraform destroy
```
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
