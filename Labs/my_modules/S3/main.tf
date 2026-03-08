terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.35.1"
    }
  }
}

resource "aws_s3_bucket" "s3" {
    bucket = var.bucket_name
    force_destroy = true

    tags = {
      Name = var.bucket_name
    }
  
}