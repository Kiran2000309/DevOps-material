
resource "aws_lb_target_group" "tg_home" {
    name = "tg-home"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
    tags = {
        env = var.env
    }
}

resource "aws_lb_target_group" "tg_laptop" {
    name = "tg-laptop"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
    tags = {
        env = var.env
    }
    health_check {
       path = "/laptop"
    }
}

resource "aws_lb_target_group" "tg_cloth" {
    name = "tg-cloth"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
    tags = {
        env = var.env
    }
    health_check {
       path = "/cloth"
    }       
}    

resource "aws_lb" "app_lb" {
    name = "app-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = var.subnet_ids
    tags = {
        env = var.env
    }
}

resource "aws_security_group" "alb_sg" {
    name = "alb-sg"
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = "0.0.0.0./0"
    }
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = 0.0.0.0./0"
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = "0.0.0.0/0"
    }
    description = "My name is kiran"
}

resource "aws_lb_listener" "app_lb_listener" {
    load_balancer_arn = aws_lb.app_lb.arn
    port = "80"
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg_home.arn
    }
}

resource "aws_lb_listener_rule" "app_lb_listener_rule_cloth" {
    listener_arn = aws_lb_listener.app_lb_listener.arn
    priority = 101
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg_cloth.arn
    }

    condition {
        path_pattern {
            values = ["/cloth*"]
        }
    }
}

resource "aws_lb_listener_rule" "app_lb_listener_rule_laptop" {
    listener_arn = aws_lb_listener.app_lb_listener.arn
    priority = 102
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg_laptop.arn
    }

    condition {
        path_pattern {
            values = ["/laptop*"]
        }
    }
}

