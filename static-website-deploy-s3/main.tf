terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.90.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

# creating random id
resource "random_id" "rand_id" {
  byte_length = 8
}

# creating s3 bucket
resource "aws_s3_bucket" "mywebapp-bucket" {
  bucket = "mywebapp-bucket-${random_id.rand_id.hex}"
}

# remove block public accessx
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
# bucket policy to make the objects in your bucket publicly readable
resource "aws_s3_bucket_policy" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp-bucket.id
  policy = jsonencode(
      {
    Version = "2012-10-17",
    Statement = [
        {
            Sid = "PublicReadGetObject",
            Effect = "Allow",
            Principal = "*",
            Action = "s3:GetObject",
            Resource = "arn:aws:s3:::${aws_s3_bucket.mywebapp-bucket.id}/*"    
        }
    ]
}
  )
}

# website configuration
resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  index_document {
    suffix = "index.html"
  }
}

# upload files to s3
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.mywebapp-bucket.bucket
  source = "./index.html"
  key = "index.html"
  content_type = "text/html"
}
resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.mywebapp-bucket.bucket
  source = "./styles.css"
  key = "styles.css"
  content_type = "text/css"
}

# output
output "name" {
  value = aws_s3_bucket_website_configuration.mywebapp.website_endpoint
}