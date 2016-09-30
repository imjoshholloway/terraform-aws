# Configure the AWS Provider
provider "aws" {
   access_key   = "${var.aws_access_key_id}"
   secret_key   = "${var.aws_secret_access_key}"
   region       = "${var.aws_region}"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket  = "imjoshholloway-terraform-state"
    acl     = "private"

    versioning {
        enabled = false
    }
}
