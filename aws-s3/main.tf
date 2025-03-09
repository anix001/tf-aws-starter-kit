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
resource "aws_s3_bucket" "demo-bucket-s3-anix" {
  bucket = "demo-bucket-${random_id.rand_id.hex}"
}

# upload files to s3
resource "aws_s3_object" "bucket-data" {
  bucket = aws_s3_bucket.demo-bucket-s3-anix.bucket
  source = "./myfile.txt"
  key = "mydata.txt"
}

# output
output "name" {
  value = random_id.rand_id.hex
}