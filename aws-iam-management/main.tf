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
  user_data = yamldecode(file("./users.yaml")).users
  user_role_pair = flatten( [for user in local.user_data: [for role in user.roles:{
   username = user.username
   role = role
  }]])
}


#creating user
resource "aws_iam_user" "users" {
  for_each = toset(local.user_data[*].username) #change the list to set cause for_each only works with set or map
  name = each.value
}

output "output" {
  value = local.user_role_pair
}

#password creation
resource "aws_iam_user_login_profile" "profile" {
  for_each = aws_iam_user.users
  user    = each.value.name
  password_length = 8
  
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

#Attaching policies
resource "aws_iam_user_policy_attachment" "main" {
  for_each = {
    for pair in local.user_role_pair :
    "${pair.username}-${pair.role}" => pair
  }

  user       = aws_iam_user.users[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}