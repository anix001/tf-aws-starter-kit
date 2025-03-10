

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.90.0"
    }
  }
  backend "s3" {
    bucket = "demo-bucket-945e583383780710"
    key = "backend.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}


# creating ec2 instance
resource "aws_instance" "myserver" {
  ami = "ami-08b5b3a93ed654d19"
  instance_type = "t2.micro"

  tags = {
    Name ="SampleServer"
  }
}