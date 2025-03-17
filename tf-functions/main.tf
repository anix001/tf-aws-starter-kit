terraform {
  
} # we are using built-in function so, we do not need any providers here.

locals {
  value= "Hello World!"
}

variable "string_list" {
  type = list(string)
  default = [ "server 1", "server 2" ]
}

output "output" {
#   value = upper(local.value)
# value = startswith(local.value, "Hello")
# value = split(" ", local.value)
# value = abs(-1)
value = length(var.string_list)
}