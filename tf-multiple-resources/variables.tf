# Creating a variable
variable "region" {
  description = "Default value of region"
  type = string
  default = "us-east-1"
}


# ec2_config
variable "ec2_config" {
  type = list(object({
    ami = string
    instance_type = string
  }))
}