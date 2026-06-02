provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "my-instance" {
    ami           = "ami-07a00cf47dbbc844c"
    instance_type = "t2.micro"
    vpc_security_group_ids =  ["sg-02f9a60b7d8fb99d8"]
  
}