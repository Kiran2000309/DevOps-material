provider "aws" {
    region = "ap-south-1"
}
resource "aws_launch_template" "launch-template_home" {
    name_prefix = "launch-template-home"
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    vpc_security_group_ids = var.security_group_id
    user_data = <<-EOF
        #!/bin/bash
        apt update -y
        apt install -y apache2
        systemctl start apache2
        echo "<h1> Hello World <h2> Welcome to Pune" > /var/www/html/index.html
    EOF
              
   tags = {
      env = var.env
    }
}

resource "aws_launch_template" "launch-template_cloth" {
    name_prefix = "launch-template-cloth"
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    vpc_security_group_ids = var.security_group_id
    user_data = <<-EOF
        #!/bin/bash
        apt update -y
        apt install -y apache2
        systemctl start apache2
        mkdir /var/www/html/cloth
        echo "<h1> THIS IS CLOTH SECTION" > /var/www/html/cloth/index.html
    EOF
              
   tags = {
      env = var.env
    }
}

resource "aws_launch_template" "launch-template_laptop" {
    name_prefix = "launch-template-laptop"
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    vpc_security_group_ids = var.security_group_id
    user_data = <<-EOF
        #!/bin/bash
        apt update -y
        apt install -y apache2
        systemctl start apache2
        echo "<h1> SALE SALE SALE ON LAPTOP" > /var/www/html/laptop/index.html
    EOF
              
   tags = {
      env = var.env
    }
}

resource "aws_autoscaling_group" "asg_home" {
    name = "asg-home"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    launch_template {
        id = aws_launch_template.launch_template_home.id
    }
    availability_zones = var.availability_zones
    tag {
        env = var.env
    }
    target_group_arns = {aws_lb_target_group.tg_home.arn}
}

resource "aws_autoscaling_policy" "asg_home" {
    name = "asg-home"
    autoscaling_group_name = aws_autoscaling_group.asg_home.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
         predefined_metric_specification {
                predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
}

resource "aws_autoscaling_group" "asg_laptop" {
    name = "asg-laptop"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    launch_template {
        id = aws_launch_template.launch_template_laptop.id
    }
    availability_zones = var.availability_zones
    tag {
        env = var.env
    }
    target_group_arns = {aws_lb_target_group.tg_laptop.arn}
}

resource "aws_autoscaling_policy" "asg_laptop" {
    name = "asg-laptop"
    autoscaling_group_name = aws_autoscaling_group.asg_laptop.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
         predefined_metric_specification {
                predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
}

resource "aws_autoscaling_group" "asg_cloth" {
    name = "asg-cloth"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    launch_template {
        id = aws_launch_template.launch_template_cloth.id
    }
    availability_zones = var.availability_zones
    tag {
        env = var.env
    }
    target_group_arns = {aws_lb_target_group.tg_cloth.arn}

resource "aws_autoscaling_policy" "asg_cloth" {
    name = "asg-cloth"
    autoscaling_group_name = aws_autoscaling_group.asg_cloth.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
         predefined_metric_specification {
                predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
}