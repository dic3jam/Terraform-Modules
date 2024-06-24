resource "aws_lb" "basic-alb" {
  name = join(var.Name, ["alb"])
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.basic_sg_alb.id]
  subnets = [for subnet in var.public_subnets : subnet]

  enable_deletion_protection = false

  tags = {
    Name = join(var.Name, ["-alb"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_lb_listener" "basic-443-listener" {
  load_balancer_arn = aws_lb.basic-alb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.ACM_ARN

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.basic-tg.arn
  }

  tags = {
    Name = join(var.Name, ["-tg"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_lb_listener" "basic-80-listener" {
  load_balancer_arn = aws_lb.basic-alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
    }
  }

  tags = {
    Name = join(var.Name, ["-tg"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_lb_target_group" "basic-tg" {
  name = "basic-tg"
  target_type = "instance"
  port = var.protocol == "HTTP" ? 80 : 443
  protocol = var.protocol
  vpc_id = var.vpc_id

  health_check {
    enabled = true
    path = "/"
    port = var.protocol == "HTTP" ? 80 : 443
    protocol = var.protocol
    matcher = "200-399"
  }

  tags = {
    Name = join(var.Name, ["-tg"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_lb_target_group_attachment" "basic-tg-attachment" {
  target_group_arn = aws_lb_target_group.basic-tg.arn
  target_id = var.target_instance_id
}


resource "aws_security_group" "basic_sg_alb" {
  name        = "basic-sg-alb"
  description = "Application Load Balancer Security Group"
  vpc_id = var.vpc_id

ingress {
    description = "Allow 443"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description = "Allow 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

egress { # Egress all allow
    description = "Egress allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name        = join(var.Name, ["basic-sg-alb"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}