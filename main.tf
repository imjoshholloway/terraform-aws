terraform {
  backend "s3" {
    bucket = "imjoshholloway-terraform-state"
    key    = "aws.state"
    region = "eu-west-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "imjoshholloway-terraform-state"
  acl    = "private"

  versioning {
    enabled = false
  }
}

