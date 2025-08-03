terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

resource "aws_s3_bucket" "static_site" {
  bucket = "crossy-road-with-three-js-static-site"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.static_site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.static_site.arn}/*"]
      }
    ]
  })
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.static_site.bucket
}
