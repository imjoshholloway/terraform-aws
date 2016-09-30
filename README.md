# terraform-aws

Basic structuring of my AWS account in terraform.

## Hosted Zones:

- imjoshholloway.co.uk
- imjoshholloway.uk

## S3 Buckets:

- imjoshholloway-terraform-state - Holds the all terraform-state files
- imjoshholloway.co.uk - Personal website

## Terraform Remote State

This repository sets up a bucket to store terraform state in using the
remote-config plugin.

```
terraform remote config -backend=s3 \
  -backend-config="bucket=imjoshholloway-terraform-state" \
  -backend-config="key=aws.state" \
  -backend-config="region=eu-west-1"
```
