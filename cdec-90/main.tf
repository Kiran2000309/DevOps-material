provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my-instance" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t3.micro"
    vpc_security_group_ids =  [aws_security_group.my-security-group.id]
    tags = {
        env = "dev"
    }
}

resource "aws_security_group" "my-security-group" {
    region = "ap-south-1"
    name        = "new-security-group"
    description = "new sg"
    ingress { 
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        env = "dev"
    }
    vpc_id = "vpc-0a9d361633d9f8713"
}