resource "aws_vpc" "my-vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "${var.project}-vpc"
        env = var.env
    }
}

resource "aws_subnet" "pri-sub" {
    cidr_block = var.pri_sub_cidr
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "${var.project}-pri-subnet"
        env = var.env
    }
}

resource "aws_subnet" "pub-sub" {
    cidr_block = var.pub_sub_cidr
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "${var.project}-pub-subnet"
        env = var.env
    }
    map_enable_public_ip_on_launch = true
}

resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "${var.project}-igw"
        env = var.env
    }
}

resource "aws_default_route_table" "my-rt" {
    default_route_table_id = aws_vpc.my-vpc.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
}

