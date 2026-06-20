provider "aws" {
    region = "ap-south-1"
}
 
module "new_vpc" {
    source = ".modules/vpc"
    vpc_cidr = "172.0.0.0/16"
    pvt_sub_cidr = "172.16.0.0/20"
    pub_sub_cidr = "172.16.16.0/20"
}  
 
module "instance" {
    source = ".modules/ec2"  
    image_id = "ami-07a00cf47dbbc844c"
    subnet_id = module.new_vpc.pub_subnet_id
    vpc_id = module.new_vpc.vpc_id
    key_pair = "terraform-key"
    project = "cbz"  
}