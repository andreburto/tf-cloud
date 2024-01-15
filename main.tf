terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  cloud {
    organization = "andreburto"

    workspaces {
      name = "tf-cloud"
    }
  }
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

locals {
  domain_url = "tf-cloud.mothersect.info"
}

resource "aws_s3_bucket" "tf_cloud" {
  bucket = local.domain_url
}

resource "aws_s3_bucket_ownership_controls" "tf_cloud" {
  bucket = aws_s3_bucket.tf_cloud.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_acl" "tf_cloud" {
  depends_on = [ aws_s3_bucket_ownership_controls.tf_cloud ]

  bucket = aws_s3_bucket.tf_cloud.id
  acl = "private"
}
