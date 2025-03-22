terraform {
  required_version = ">=1.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.92" #In future everyone can use this module >= 
    }
  }
}
