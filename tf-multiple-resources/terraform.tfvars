ec2_config = [
  {
    ami           = "ami-04b4f1a9cf54c11d0" #ubuntu
    instance_type = "t2.micro"
  },
  {
    ami           = "ami-08b5b3a93ed654d19" #amazon linux
    instance_type = "t2.micro"
}]

ec2_map = {
  #key=value
  "ubuntu" = {
    ami           = "ami-04b4f1a9cf54c11d0" #ubuntu
    instance_type = "t2.micro"
  },
  "amazon-linux" = {
    ami           = "ami-08b5b3a93ed654d19" #amazon linux
    instance_type = "t2.micro"
  }
}