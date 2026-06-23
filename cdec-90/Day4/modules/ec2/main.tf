resource aws instance "my_instance" {
    ami           = "var.ami_id"
    instance_type = "var.instance_type"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    subnet_id = "var.subnet_id"
    key_name = "var.key_name"
    tags = {
        Name = "${var.project}-instance"
  }
}

resource "aws_security_group" "my_sg" {
    description = "enable 80 and 22"
    tags = {
        Name = "${var.project}-sg"
    }
    vpc_id      = "var.vpc_id"
    ingress {
         from_port   = 80
         to_port     = 80
         protocol    = "TCP"
         cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 22
        to_port     = 22
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}