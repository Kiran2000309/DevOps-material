
variable "image_id" {
    default = "ami-07a00cf47dbbc844c"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "security_group_id" {
    default = "sg-02f9a60b7d8fb99d8"
}

variable "key_pair" {
    default = "terraform"
}

variable "env" {
    default = "dev"
}

variable "min_size" {
    default = "2"
}

variable "max_size" {
    default = "5"
}

variable "desired_capacity" {
    default = "2"
}

variable "availability_zones" {
    default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "vpc_id" {
    default = "vpc-0a9d361633d9f8713"
}

variable "subnet_ids" {
    default = ["subnet-01508b93fba02224b","subnet-0015260c01707b81c"]
}