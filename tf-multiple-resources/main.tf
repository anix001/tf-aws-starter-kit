terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.90.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

locals {
  project = "project-01"
}

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.project}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  count = 2 #run 2 times 
  tags = {
    Name = "${local.project}-subnet-${count.index}"
  }
}

# creating four ec2 instances
# resource "aws_instance" "main" {
#   ami = "ami-08b5b3a93ed654d19"
#   instance_type = "t2.micro"
#   count = 4 # run 4 times
#   subnet_id = element(aws_subnet.main[*].id, count.index%length(aws_subnet.main)) # assigning 2 ec2instances in each subnet
#   # 0%2 = 0
#   # 1%2 = 1
#   # 2%2 = 0
#   # 3%2 = 1

#   tags = {
#     Name = "${local.project}-instance-${count.index}"
#   }
# }

# creating 2 instances with different ami 
resource "aws_instance" "main" {
  count = length(var.ec2_config) #runs 2 times

  ami = var.ec2_config[count.index].ami
  instance_type = var.ec2_config[count.index].instance_type

  subnet_id = element(aws_subnet.main[*].id, count.index%length(aws_subnet.main))

  tags = {
    Name = "${local.project}-instance-${count.index}"
   }
}

output "aws_subnet_id" {
  value = aws_subnet.main[0].id
}
