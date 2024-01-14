terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    encrypt = true
    bucket = "mothersect-tf-state"
    dynamodb_table = "mothersect-tf-state-lock"
    key    = "tf-cloud"
    region = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

locals {
  domain_url = "tf-cloid-mothersect.info"
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
