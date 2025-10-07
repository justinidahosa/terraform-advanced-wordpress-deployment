resource "aws_lb" "wp_alb" {
  name               = "wp-alb"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.public_subnet_3.id
  ]

  security_groups = [
    aws_security_group.alb_sg.id
  ]
}

resource "aws_lb_target_group" "wordpress_tg" {
  name        = "wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.wp_vpc.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "wordpress-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.wp_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "wordpress_tg_attachment" {
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = aws_instance.wordpress.id
  port             = 80
}


